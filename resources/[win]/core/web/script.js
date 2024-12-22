let engineOn = false
let openedMenu = false;

$(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action){
            case 'watermark':
                updateWatermark(event.data)
                break
            case 'hud':
                handleHudListen(event.data.data)
                break
            case 'notification':
                sendNotification(event.data.notification)
                break
            case 'progress':
                addProgressBar(event.data.progress)
                break
            case 'progress-cancel':
                cancelProgress()
                break
            case 'image':
                useRecording(true).handleRecord(15000).then((blob) => {
                    handleFileUpload(blob, event.data.info)
                })
                break
            case 'video':
                useRecording(false).handleRecord(event.data.info.time + 500).then((blob) => {
                    handleFileUpload(blob, event.data.info)
                })
                break
            case 'org-top':
                handleOrgRequest(event.data.switch, event.data.data)
                break
            case 'animations':
                handleAnimationsListen(event.data.data)
                break
            case 'brutallywounded':
                handleBW(event.data.data)
                break
            case 'toggle':
                if (event.data.state) {
                    $('#scoreboard-wrapper').fadeIn('fast');
                } else {
                    $('#scoreboard-wrapper').fadeOut('fast');
                }
                break;
            case 'update':
                Object.entries(event.data.data).forEach(([type, info]) => {
                    $(`#${type}`).html(info);
                });
                break;
            case 'garage':
                handleGarageListen(event.data.data)
                break
        }

        if(event.data.showhud){
            $('.speedometer').show();
            $(".streetlabel").css('display', 'inline-flex');
            engineOn = true
        }
    
        if(event.data.showhud == false){
            $('.speedometer').hide();
            $('.streetlabel').hide();
            engineOn = false
        }
        
        if(event.data.speed && event.data.percent) {
            let speed = Number(event.data.speed)
            let percent = Number(event.data.percent)
            let showpercent = (percent * 0.65)
            if(speed < 10){
                $(".speed-digital").text("00" + speed)
            }
            else if(speed < 100){
                $(".speed-digital").text("0" + speed)
            }
            else{
                $(".speed-digital").text(speed)
            }

            $('.speed').attr('stroke-dasharray', showpercent + ' 100')
        }
    
        if(event.data.rpmx) {
            let rpm = (Number(event.data.rpmx) * 0.65)
            $('.tacho path').attr('stroke-dasharray', rpm + ' 100')
        }

        if(event.data.street){
            $(".street").text(event.data.street)
        }

        if(event.data.direction){
            $(".direction").text(event.data.direction)
        }

        if(event.data.type == 'pause-open'){
            openedMenu = true;
            $('#pause-wrapper').fadeIn('fast');
        }

        if(event.data.type == 'pause-close'){
            openedMenu = false;
            $('#pause-wrapper').fadeOut('fast');
        }
    })

    $("#garage-close-button").on('click', function() {
        handleGarageListen({close: true})
    })

    $("#garage-impound-all").on('click', async function() {
        try {
            const res = await axios.post(`https://${GetParentResourceName()}/SpaceRP:garage`, {
                action: 'tow-all'
            })
            .catch((err) => {
                console.log(err)
            })

            if (res.data) {
                handleGarageClose()
            } else {
                // cos tu dodam ni
                // dodaj że trzepie ci na boki dany przycisk
            }
        } catch (err) {
            // console.log(err)
        }
    })

    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            if ($("#garage-container").css('display') == 'block') {
                handleGarageClose()
            }
        }
    })


    $("#garage-car-search-input").on("keyup", function() {
        var value = $(this).val().toLowerCase()
        var carWrappers = $('.car-wrapper');

        carWrappers.each(function() {
            var carName = $(this).find('.car-header span').text().toLowerCase()
            var carPlate = $(this).find('#car-header-plate').text().toLowerCase()

            if (carName.indexOf(value) >= 0 || carPlate.indexOf(value) >= 0) {
                $(this).show();
            } else {
                $(this).hide();
            }
        })
    })
})

function updateWatermark(data) {
    if(data.playerID){
        $('#player-id').html(data.playerID)
    }
}

let hudtype = 'unset'

const Hud = {
    cache: {},
    display: {
        global: function(val) {
            $('#player-hud-wrapper').css('display', val ? 'block' : 'none');
        },
        player: function(val) {
            $('#player-hud-wrapper').css('display', val ? 'block' : 'none');
        },
    },
    aspectWidthMap: {
        1500: '16.7%',
        1333: '18.75%',
        1666: '15%',
        1250: '20%',
        1777: '14.05%',
        1600: '15.65%'
    },
    player: {
        ["health"]: {
            icon: "heart",
            colors: {
                ["new"]: "220, 220, 220",
                ["old"]: {
                    ["bar"]: "0, 255, 0, .8",
                    ["background"]: "57, 102, 57, .6"
                }
            },
            oldbar: 1
        },
        ["armor"]: {
            icon: "shield",
            colors: {
                ["new"]: "220, 220, 220",
                ["old"]: {
                    ["bar"]: "93, 182, 229, .8",
                    ["background"]: "47, 92, 115, .6"
                }
            },
            hide: {
                new: 0,
            },
            oldbar: 2,
        },
        ["voice"]: {
            icon: "microphone",
            colors: {
                ["new"]: "220, 220, 220",
                ["old"]: {
                    ["bar"]: "255, 255, 255, .5",
                    ["background"]: "106, 106, 106, 0.5"
                }
            },
            oldbar: 3,
        }
    }
}

$(function() {
    Hud.cache['isTalking'] = false;

    $("#old-hud-wrapper").append(`
        <div id="old-hud-container">
            <div class="upper-container">
                <div class="bar-group-wrapper" id="old-hud-bar-1"></div>
                <div class="bar-group-wrapper" id="old-hud-bar-2"></div>
            </div>
            <div class="lower-container">
                <div class="bar-group-wrapper" id="old-hud-bar-3"></div>
            </div>
        </div>
    `);

    for (const [key, value] of Object.entries(Hud.player)) {
        const hide = Hud.player[key]?.hide || {};
        const vals = { new: hide.new ?? 50, old: hide.old ?? 50 };

        if (vals.new == 50) { // Jeśli ikonka nie jest ukryta, twórz kontener
            $("#new-hud-wrapper").append(`
                <div class="icon-container" id="${key}-container">
                    <i id="${key}-icon" class="fa-solid fa-${value.icon}" style="background: -webkit-linear-gradient(bottom, rgb(${value.colors['new']}) ${vals.new}%, rgb(150, 150, 150) ${100 - vals.new}%); -webkit-background-clip: text"></i>
                </div>
            `);
        }

        $(`#old-hud-bar-${value.oldbar}`).append(`
            <div id="${key}-bar" class="status-bar ${vals.old == 50 ? '' : 'icon-hidden'}" style="background: linear-gradient(90deg, rgba(${value.colors['old']['bar']}) ${vals.old}%, rgba(${value.colors['old']['background']}) 0%)"></div>
        `);
    }

    $(`#player-hud-wrapper`).fadeIn('fast');
    hudtype = localStorage.getItem('hudtype-space') || 'new';
    $(`#${hudtype}-hud-content`).fadeIn('fast');
});

function toggleIconDisplay(icon, visibility) {
    const iconContainerId = `#${icon}-container`;

    if (visibility) {
        if (!$(iconContainerId).length) { // Jeśli kontener nie istnieje, dodaj go
            $("#new-hud-wrapper").append(`
                <div class="icon-container" id="${icon}-container">
                    <i id="${icon}-icon" class="fa-solid fa-${Hud.player[icon].icon}" style="background: -webkit-linear-gradient(bottom, rgb(${Hud.player[icon].colors['new']}) ${50}%, rgb(150, 150, 150) ${50}%); -webkit-background-clip: text"></i>
                </div>
            `);
        }
        $(`#${icon}-container`).fadeIn('fast');
    } else {
        $(iconContainerId).fadeOut('fast', function() {
            $(this).remove(); // Usuwamy kontener gdy ikona jest ukryta
        });
    }
}

function handleSwitchHudTypeChange() {
    $(`#${hudtype}-hud-content`).fadeOut('fast')
    hudtype = hudtype == 'new' ? 'old' : 'new'
    localStorage.setItem('hudtype-space', hudtype)
    $(`#${hudtype}-hud-content`).fadeIn('fast')
}

function handleHudUpdate(data) {
    if (data.player) {
        for (let [key, value] of Object.entries(data.player)) {
            if (Hud.cache[key] != value) {
                Hud.cache[key] = value;

                if (key == 'aspectRatio') {
                    $(`#old-hud-container`).width(Hud.aspectWidthMap[Math.floor(value * 1000)] || '14.05%');
                }

                if (key == 'isTalking') {
                    key = 'voice';
                    value = Hud.cache['voice'] || 50;
                }

                const { colors = {}, hide = {}, icon } = Hud.player[key] || {};

                const isHidden = hide.new === value;
                toggleIconDisplay(key, !isHidden); // Pokazuje lub ukrywa kontener ikony

                $(`#${key}-bar`).replaceWith(`
                    <div id="${key}-bar" class="status-bar ${hide.old === value ? 'icon-hidden' : ''}" style="background: linear-gradient(90deg, rgba(${(key === 'voice' && Hud.cache?.isTalking ? '107,50,168,.7' : colors.old?.bar || '0,0,0')}) ${value}%, rgba(${(key === 'voice' && Hud.cache?.isTalking ? '106,106,106,.5' : colors.old?.background || '0,0,0')}) 0%)"></div>
                `);

                $(`#${key}-icon`).replaceWith(`
                    <i id="${key}-icon" class="fa-solid fa-${icon}" style="background: -webkit-linear-gradient(bottom, rgb(${(key === 'voice' && Hud.cache?.isTalking ? '110,60,150' : colors.new || '0,0,0')}) ${value}%, rgb(150,150,150) ${value}%); -webkit-background-clip: text"></i>
                `);
            }
        }
    }
}

function handleHudListen(data) {
    if (data.toggle != null) {
        if (data.toggle.global != null) {
            Hud.display.global(data.toggle.global)
        }

        if (data.toggle.player != null) {
            Hud.display.player(data.toggle.player)
        }
    }

    if (data.switch) {
        handleSwitchHudTypeChange()
    }

    if (data.update != null) {
        handleHudUpdate(data.update)
    }
}

const notification_types = {
    ['success']: {
        ['icon']: 'fa-solid fa-square-check',
        ['color']: '0, 160, 80'
    },
    ['error']: {
        ['icon']: 'fa-solid fa-triangle-exclamation',
        ['color']: '200, 55, 0'
    },
    ['info']: {
        ['icon']: 'fa-solid fa-circle-info',
        ['color']: '45, 50, 55'
    }
}

const notification_colors = {
    w: '#FFFFFF', s: '#FFFFFF', u: '#000000', r: '#DA1918', g: '#A3FF12',
    b: '#0099CC', y: '#FFCC00', o: '#F76A2E', p: '#651FFF',
}

const colorFormatString = (str) => str.replace(/~([^h])~([^~]+)/g, (match, color, text) => match = `<span style="color: ${notification_colors[color]}">${text}</span>`)

function sendNotification(data) {
    let title = data.title && `<b>${data.title}</b><br>` || '&#8203;'
    let color = data.color || '45, 50, 55'
    let icon = data.icon || 'fa-solid fa-bell'
    let text = colorFormatString(data.text) || 'N/A'
    let duration = data.duration || 5000

    if (data.type) {
        icon = notification_types[data.type]['icon']
        color = notification_types[data.type]['color']
    }

    var temp = $(
        `<div class='notification' style='background: rgba(${color},.9);'>
            <i class='${icon}'></i>
            ${title}
            ${text}
        </div>`
    )
    $('#notifications-wrapper').append(temp)    
    temp.fadeIn('fast')

    setTimeout(function() {
        temp.fadeOut('fast', function() {
            temp.remove()
        })
    }, duration)
}

let id = 0
let ids = []

function addProgressBar(data) {
    id++
    ids.push(id)

    var temp = $(
        `<div class='progress' id='progress-${id}'>
            <p class='text'>${data.title}</p>
            <p class='timer' id='timer-${id}'>N/A</p>
            <div class='bar' id='bar-${id}'></div>
        </div>`
    )

    $('#progress-wrapper').append(temp)

    countDown(temp, parseInt(data.time), id)
}

function countDown(elem,time,id) {
    $(`#bar-${id}`).css({'width': '100%'}).animate({
        width: '0%'
    }, {
        duration: parseInt(time),
        progress: function(a,b,c) {
            $(`#timer-${id}`).html(parseFloat(c / 1000).toFixed(2))
        },
        complete: function() {
            ids.splice(ids.indexOf(id), 1)

            axios.post(`https://${GetParentResourceName()}/win:progressFinished`, {
                id: id,
            }).catch(()=>{})

            elem.fadeOut('fast', function() {
                elem.remove()
            })
        }
    })
}

function cancelProgress() {
    let queue = 0
    let total = ids.length
    
    for (let i of ids) {
        axios.post(`https://${GetParentResourceName()}/win:progressCanceled`, {
            id: i,
        }).catch(() => {})

        let progress = $(`#progress-${i}`)
        let timer = $(`#timer-${i}`)
        let bar = $(`#bar-${i}`)

        bar.stop()
        timer.html('Anulowano')
        bar.css('background', '#ff0000')

        setTimeout(function() {
            progress.fadeOut('fast', function() {
                progress.remove()
            })
        }, 2500)

        queue++
        if (total == queue) {
            ids = []
        }
    }
}

var vertexShaderSrc= "\n  attribute vec2 a_position;\n  attribute vec2 a_texcoord;\n  uniform mat3 u_matrix;\n  varying vec2 textureCoordinate;\n  void main() {\n    gl_Position = vec4(a_position, 0.0, 1.0);\n    textureCoordinate = a_texcoord;\n  }\n",fragmentShaderSrc="\nvarying highp vec2 textureCoordinate;\nuniform sampler2D external_texture;\nvoid main()\n{\n  gl_FragColor = texture2D(external_texture, textureCoordinate);\n}\n",makeShader=function(e,r,t){var a=e.createShader(r);if(null!=a){e.shaderSource(a,t),e.compileShader(a);var n=e.getShaderInfoLog(a);return n&&console.error(n),a}},createTexture=function(e){var r=e.createTexture(),t=new Uint8Array([0,0,255,255]);return e.bindTexture(e.TEXTURE_2D,r),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,1,1,0,e.RGBA,e.UNSIGNED_BYTE,t),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_MAG_FILTER,e.NEAREST),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_MIN_FILTER,e.NEAREST),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_S,e.CLAMP_TO_EDGE),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.MIRRORED_REPEAT),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.REPEAT),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE),r},createBuffers=function(e){var r=e.createBuffer();e.bindBuffer(e.ARRAY_BUFFER,r),e.bufferData(e.ARRAY_BUFFER,new Float32Array([-1,-1,1,-1,-1,1,1,1]),e.STATIC_DRAW);var t=e.createBuffer();return e.bindBuffer(e.ARRAY_BUFFER,t),e.bufferData(e.ARRAY_BUFFER,new Float32Array([0,0,1,0,0,1,1,1]),e.STATIC_DRAW),{vertexBuff:r,texBuff:t}},createProgram=function(e){var r=makeShader(e,e.VERTEX_SHADER,vertexShaderSrc),t=makeShader(e,e.FRAGMENT_SHADER,fragmentShaderSrc),a=e.createProgram();e.attachShader(a,r),e.attachShader(a,t),e.linkProgram(a),e.useProgram(a);var n=e.getAttribLocation(a,"a_position"),i=e.getAttribLocation(a,"a_texcoord");return{program:a,vloc:n,tloc:i}},createGameView=function(e){var r=null==e?void 0:e.getContext("webgl",{antialias:!1,depth:!1,stencil:!1,alpha:!1,desynchronized:!0,failIfMajorPerformanceCaveat:!1}),t=function(){},a=function(){var e=createTexture(r),a=createProgram(r),n=a.program,i=a.vloc,o=a.tloc,E=createBuffers(r),T=E.vertexBuff,R=E.texBuff;r.useProgram(n),r.bindTexture(r.TEXTURE_2D,e),r.uniform1i(r.getUniformLocation(n,"external_texture"),0),r.bindBuffer(r.ARRAY_BUFFER,T),r.vertexAttribPointer(i,2,r.FLOAT,!1,0,0),r.enableVertexAttribArray(i),r.bindBuffer(r.ARRAY_BUFFER,R),r.vertexAttribPointer(o,2,r.FLOAT,!1,0,0),r.enableVertexAttribArray(o),r.viewport(0,0,r.canvas.width,r.canvas.height),t()},n={canvas:e,gl:r,animationFrame:void 0,resize:function(e,t){r.viewport(0,0,e,t),r.canvas.width=e,r.canvas.height=t}};return t=function(){r.drawArrays(r.TRIANGLE_STRIP,0,4),r.finish(),n.animationFrame=requestAnimationFrame(t)},a(),n};
const useRecording = (isImage) => {
    const canvasRef = document.getElementById("game")
    const handleRecord = async (time) => {

        createGameView(canvasRef)
        if (!canvasRef) return

        const stream = canvasRef.captureStream(isImage ? 1 : 30)
        if (!stream) {
            return
        }

        return new Promise((resolve, reject) => {
            if (isImage) {
                const image = canvasRef.toDataURL("image/jpeg", 0.7)
                resolve({
                    image: image,
                    is: isImage
                })
            } else {
                const options = {
                    //videoBitsPerSecond: 2500000,
                }

                const mediaRecorder = new MediaRecorder(stream, options)
                const chunks = []

                mediaRecorder.ondataavailable = (e) => e.data.size > 0 && chunks.push(e.data)
                mediaRecorder.onstop = (e) => {
                    const completeBlob = new Blob(chunks, {
                        type: chunks[0].type
                    })
                    resolve({
                        image: completeBlob,
                        is: isImage
                    })
                }
                mediaRecorder.start()

                setTimeout(() => {
                    mediaRecorder.stop()
                }, time || 0)
            }
        })
    }

    return {
        handleRecord
    }
}

const handleFileUpload = (imageData, data) => {
    const domain = data.domain
    const dataTwo = {
        authKey: data.authKey,
        reason: data.reason,
        id: data.id,
        src: data.src,
    }
    if (imageData.is) {
        axios.post(`https://${domain}/upload/image`, {
            proxy: {
                port:8080,
                host:"127.0.0.1"
            },
            body: JSON.stringify({
                base64: imageData.image,
                data: dataTwo
            }),
        })
    } else {
        const reader = new FileReader()

        reader.onload = (event) => {
            if (!event.target) {
                return
            }

            const base64 = event.target.result
            if (base64) {
                axios.post(`https://${domain}/upload/video`, {
                    proxy: {
                        port:8080,
                        host:"127.0.0.1"
                    },
                    body: JSON.stringify({
                        base64: base64,
                        data: dataTwo
                    })
                })
            }
        }
        reader.readAsDataURL(imageData.image)
    }
}

function handleOrgRequest(display, data) {
    if (display) {
        $("#btk").append(`<table id="btki"><tr><th>#</th><th>Organizacja</th><th>LVL</th></tr></table>`)
        for (let i = 0; i < 11; i++) {
            const organization = data.bitki[i]
            if (i == 10) {
                $("#btk-me").append(`<table><tr><td>#</td><td>${organization.label}</td><td>${organization.lvl}</td></tr></table>`)
                break
            }
            $("#btki").append(`<tr><td>${Number(i)+1}</td><td>${organization.label}</td><td>${organization.lvl}</td></tr>`);
        }

        for (const [k,v] of Object.entries(data.strefy)) {
            $("#stf").append(`<table><tr><td><i class="fa-solid fa-house-flag"></i>${k}</td><td><i class="fa-solid fa-users"></i>${v.label}</td><td><i class="fa-solid fa-swords"></i>${v.captures}</td></tr></table>`);
        }

        $("#usr").append(`<table id="usrs"><tr><th>#</th><th>Gracz</th><th>Punkty</th></tr></table>`)
        for (let i = 0; i < 11; i++) {
            const user = data.gracze[i]
            if (i == 0) {
                $("#usr-me").append(`<table><tr><td>#</td><td>${user.label}</td><td>${user.points}</td></tr></table>`)
            } else {
                $("#usrs").append(`<tr><td>${Number(i)}</td><td>${user.label}</td><td>${user.points}</td></tr>`);
            }
        }

        $('#top-organizations-box')
            .css("display", "flex")
            .hide()
            .fadeIn('fast');

            $(document).keyup(function(e) {
                if (e.key === "Escape" || e.key === "Backspace") { 
                    handleHideOrg()
                    axios.post(`https://${GetParentResourceName()}/win:shutDownTopka`).catch(() => {});
               };
           });
    } else {
        handleHideOrg()
    }
}

function handleHideOrg() {
    $('#top-organizations-box').fadeOut('fast', function() {
        $("#btk, #usr, #stf, #btk-me, #usr-me").empty()
    });
}

let countdown

function handleBW(data) {
    if (data.respawn) {
        if (countdown != undefined) {
            clearInterval(countdown)
        }

        $(`#death-screen`).fadeOut('fast');
        return
    }

    $(`#death-screen`).fadeIn('slow');

    $(`#bw-container`).css('padding-bottom', '5vh')
    $(`#bw-container`).html(`
        <h1>Nie żyjesz</h1>

        <span>Odrodzenie dostępne za<br><b id="bw-time">0:30</b></span>
        <div class="death-wrapper-image-container">
            <img id="bw-pulse" src="images/pulse.gif">
        </div>
    `)

    const startTime = Date.now()
    const duration = data.time

    countdown = setInterval(() => {
        const elapsed = Date.now() - startTime;
        const left = parseFloat((duration - elapsed) / 1000).toFixed(2);
        const elapsedSeconds = Math.floor(left);
        const minutes = Math.floor(elapsedSeconds / 60);
        const seconds = elapsedSeconds % 60;
        $(`#bw-time`).html(`${minutes}:${seconds.toString().padStart(2, '0')}`);

        if (elapsed >= duration) {
            clearInterval(countdown)
            
            axios.post(`https://${GetParentResourceName()}/win:bw-finished`).catch(()=>{})

            $(`#bw-container`).css('padding-bottom', '7vh')
            $(`#bw-container`).html(`
                <h1>Nie żyjesz</h1>
                <span>Przytrzymaj <b>[E]</b> aby transportować się na greenzone</span>

                <div class="death-wrapper-image-container">
                    <img id="bw-pulse" src="images/pulse.gif">
                </div>
            `)
        }
    }, 1000)
}

let adjustments_cache = {}

function handleAnimationsListen(event) {
    switch (event.key) {
        case 'binding':
            localStorage.setItem("binding", event.data);
            break
        case 'adjustment':
            if (event.data.toggle != undefined) {
                $(`#animation-adjustment`)[event.data.toggle ? 'fadeIn' : 'fadeOut']('fast');
            }
            if (event.data.values != undefined) {
                Object.entries(event.data.values).forEach(([type, info]) => {
                    if (adjustments_cache[type] != info) {
                        adjustments_cache[type] = info
                        $(`#a-${type}`).html(info)
                    }
                })
            }
            break
    }
}

$(document).ready(function() {
    const buttons = document.querySelectorAll('button')

    buttons.forEach(button => {
       button.addEventListener('click', event => {
            if (event.target.id == 'discord') {
                window.invokeNative('openUrl', 'https://discord.gg/wingg')
            } else {
                $.post(`https://${GetParentResourceName()}/button`, JSON.stringify({
                    type: event.target.id
                }));
            }
       });
    });
});

$(document).keydown(function(e) {
    if(e.key == 'Escape' && openedMenu) {
        $.post(`https://${GetParentResourceName()}/button`, JSON.stringify({
            type: 'return'
        }));
        openedMenu = false;
    }
});

const garage_state = {
    0: {
        text: 'POZA GARAŻEM',
        color: '255, 0, 0'
    },
    1: {
        text: 'W GARAŻU',
        color: '0, 255, 0'
    },
    2: {
        text: 'ODHOLOWANY',
        color: '3, 161, 252'
    },
}

function handleGarageListen(data) {
    if (data.close) {
        handleGarageClose()
        return
    }

    for (let i in data.cars) {
        addGarageCar({ ...data.cars[i], id: i })
    }

    $("#garage-car-search-input").val(``)
    $("#garage-header-vehicles").text(`Pojazdy - ${data.cars.length}`)

    $('.car-header').click(function() {
        $(this).parent().toggleClass('open')
    })

    $('.car-content-buttons > button').click(function() {
        handleButtonClick($(this).attr('action'), $(this).parent().attr('plate'))
    })

    $("#garage-container").fadeIn()
}

async function handleButtonClick(action, plate) {
    try {
        const res = await axios.post(`https://${GetParentResourceName()}/SpaceRP:garage`, {
            action: action,
            plate: plate
        }).catch(()=>{})

        if (res.data) {
            handleGarageClose()
        } else {
            // cos tu dodam ni
            // dodaj że trzepie ci na boki dany przycisk
        }
    } catch (err) {
        // console.log(err)
    }
}

function handleGarageClose() {
    axios.post(`https://${GetParentResourceName()}/SpaceRP:setNuiFocus`, {}).catch(()=>{})
    $("#garage-container").fadeOut('fast', () => {
        $("#garage-cars").empty()
    })
}

function addGarageCar(data) {
    const action = data.inGarage ? 'out' : 'tow'
    const buttons = `
        <button class="car-content-button button ${action}" action="${action}">
            ${data.inGarage ? 'Wyjmij' : 'Sprowadź'} pojazd
        </button>
        <button class="car-content-button button give" action="give">
            Nadaj współwłaściciela
        </button>
    `
    let currentCar = {}

    for (const key in data.health) {
        const value = data.health[key];
       
        let color = "green"

        if (value <= 600) {
            color = "yellow"
        } else if (value <= 350) {
            color = "red"
        }
        
        currentCar[key] = {
            percentage: `${(value / 10).toFixed(1)}%`,
            color: color
        }
    }

    $("#garage-cars").append(`<div class="car-wrapper" id="${data.id}">
        <div class="car-header">
            <div class="car-header-icon flex-center">
                <i class="fa-duotone fa-car"></i>
            </div>
            <span>${data.model}</span>
            <div class="flex-center">
                <span id="car-header-plate">${data.plate}</span>
            </div>
            <div class="car-header-right-side flex-center">
                <div id="car-header-status" style="background: rgba(${garage_state[data.inGarage].color}, .5)">${garage_state[data.inGarage].text}</div>
                <div id="car-header-fold-icon">
                    <i class="fa-solid fa-angle-down"></i>
                </div>
            </div>
        </div>
        <div class="car-content">
            <table class="flex-center">
                <tr>
                    <td><i class="fa-duotone fa-key"></i>Właściciel pojazdu: </td>
                    <td><div class="car-content-box background-${data.ownerState ? 'green' : 'red'}">${data.ownerState ? 'Tak' : 'Nie'}</div></td>
                </tr>
                <tr>
                    <td><i class="fa-duotone fa-car-rear"></i>Tablica rejestracyjna: </td>
                    <td><div class="car-content-box">${data.plate}</div></td>
                </tr>
                <tr>
                    <td><i class="fa-duotone fa-engine"></i>Stan silnika: </td>
                    <td><div class="car-content-box background-${currentCar.engine.color}">${currentCar.engine.percentage}</div></td>
                </tr>
                <tr>
                    <td><i class="fa-duotone fa-car-burst"></i>Stan karoserii: </td>
                    <td><div class="car-content-box background-${currentCar.body.color}">${currentCar.body.percentage}</div></td>
                </tr>
                <tr>
                    <td><i class="fa-duotone fa-gears"></i>Stan skrzyni biegów: </td>
                    <td><div class="car-content-box background-${currentCar.tank.color}">${currentCar.tank.percentage}</div></td>
                </tr>
                
            </table>
            <div class="car-content-buttons flex-center" plate="${data.plate}">${buttons}</div>
        </div>
    </div>`)
}