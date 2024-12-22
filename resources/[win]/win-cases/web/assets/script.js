config = {};
config.date = "June 1, 2024 00:00:00";

const lib = {}
const load = {}
const start = {}

lib.currencies = { ["premium"]: "GC", ["nonPremium"]: "SC" }
lib.rareTypes = { ["legendary"]: 0, ["mythical"]: 1, ["rare"]: 2, ["common"]: 3}
lib.isOpening = false
lib.loaded = false
lib.config = {}

$(window).on("message", function (e) {
	const data = e.originalEvent.data

	switch (data.action) {
		case "open-container":
			load.container(data.value)
			break
        case "last-drop":
            lib.drop(data.value.newDrop)
            break
        case "load-html":
            load.html()
            break
	}
})

load.drops = function(val) {
    $("#last-drops").empty()
    for (const entry of val) {lib.drop(entry)}
}

start.sound = function(sfx, vol) {
    audioPlayer = new Howl({src: [`./assets/sounds/${sfx}.ogg`]});
    audioPlayer.volume(vol);
    audioPlayer.play();
}

lib.drop = function(val) {
    let chest = lib.config[val.caseType][val.caseId]
    let item = chest.drop[val.rareType][val.itemIteration]
    let $drop = $(`
        <a class="drop jump" draggable="false">
            <img class="hide icon" src="assets/img/${item.image}" alt="item-drop" draggable="false">
            <p class="hide item white font-montserrat overflow">${item.label}</p>
            <p class="hide case white font-montserrat overflow">${chest.label}</p>
            <div class="hover-drop">
                <img src="${val.user.image}">
                <p id="nickname-last-drop" class="case white font-montserrat overflow">${val.user.name}</p>
            </div>
        </a> 
    `)

    $("#last-drops").prepend($drop)
    setTimeout(() => {
        $drop.removeClass('jump')
    }, 300);
}

load.container = function(val) {
	lib.config = val.config
    load.html()
    lib.updateCoins(val.coins)
    load.drops(val.lastDrops)
	load.cases(lib.config)

	$("#h3h3").fadeIn("fast")
}

load.cases = function(config) {
    $("#premium-cases, #nonPremium-cases, #banner-cases").empty()

	Object.entries(config).forEach(([type, data]) => {
		for (let i = 0; i < data.length; i++) {
			const item = data[i]         

			const currentCase = `
                <div class='case-wrapper' id='case-${type}-${i}'>
                    <a>
                        <img loading='lazy' src='assets/img/${item.CaseImage}' class='case'>
                        <div class='item-container'>
                            <img loading='lazy' src='assets/img/${item.ItemImageAboveCaseImage}' class='item'>
                        </div>
                        <header>
                            <h3 class='name font-montserrat'>${item.label}</h3>
                            <h3 class='price font-montserrat'>
                                <p>${item.price} ${lib.currencies[type]}</p>
                            </h3>
                            <h4 class='hover font-montserrat'>OTWÓRZ</h4>
                        </header>
                    </a>
                </div>
            `

			$((item.inBanner && "#banner-cases") || `#${type}-cases`).append(currentCase)
		}
	})
	$(`.case-wrapper`).click(function() {
		const [, type, id] = $(this).attr("id").split("-")
		load.opening(type, id)
	})
}

load.opening = function (caseType, caseId) {
	const data = lib.config[caseType][caseId]
	const allItems = []
    const availableDrops = []

	$("#open-case").unbind("click")
	$("#main-wrapper").fadeOut("fast")

    $("#case-opening").empty().append(`
        <div class='container'>
            <div class='content'>
                <button id='back-to-main' class='case-btn'>
                    <p class='font-montserrat white'>Wróć na stronę główną</p>
                </button>
                <div class='title'>
                    <div class='title-icon'>
                        <img loading='lazy' class='z' src='assets/img/${data.ItemImageAboveCaseImage}'>
                        <img loading='lazy' src='assets/img/${data.CaseImage}'>
                    </div>
                    <h2 class='font-montserrat white'>${data.label}</h2>
                </div>
                <div id='case-roll'>
                    <div class='case-roll-wrapper'></div>
                    <div class='case-roll-arrow'></div>
                    <div class='case-roll-items-wrapper'>
                        <div id='case-roll-items'></div>
                    </div>
                </div>
                <div id='case-btns'>
                    <button id='open-case'class='case-btn'>
                        <p class='font-montserrat white upper'>OTWÓRZ SKRZYNKĘ ${data.label} ZA ${data.price} ${lib.currencies[caseType]}</p>
                    </button>
                </div>
                <div class='title' style='padding-bottom: 15px; border-bottom: 1px solid hsl(0, 0%, 20%)'>
                    <h2 class='font-montserrat white'>ZAWARTOŚĆ SKRZYNKI</h2>
                </div>
                <div id='case-available-items'></div>
            </div>
        </div>
    `)

	setTimeout(() => {
		$("#case-opening").fadeIn("fast")
	}, 400)

	$("#back-to-main").click(() => {
        $("#case-opening").fadeOut('fast', function(){
            setTimeout(() => {
                start.back()
            }, 100);
        })
    })

	axios.post(`https://wingg-cases/checkBalance`, {
        caseType: caseType,
        caseId: parseInt(caseId),
    }).then((tmp) => {
        let res = tmp.data
        let btn = $("#open-case")

        if (!res.canBuy) {
            btn.prop('disabled', true)
            return
        } else {
            btn.click(() => {
                start.opening(caseType, caseId)
            })
        }
    }).catch(() => {})

	Object.entries(data.drop).forEach(([variety, items]) => {
		items.forEach((item) => {
			item.variety = variety
			allItems.push(item)
            if(!availableDrops[item.variety]) availableDrops[item.variety] = []
            availableDrops[item.variety].push(item)
		})
	})

	Object.entries(availableDrops).forEach(([variety, items]) => {
        const id = lib.rareTypes[variety]
        const name = `${id}-${variety}-drops`

        $("#case-available-items").append(`<div class="row" id="${name}"></div>`)

        items.forEach((item) => {
            $(`#${name}`).append(`
                <a class='drop ${variety}' dragable='false'>
                    <img class='icon' src='assets/img/${item.image}' alt='item-drop' draggable='false'>
                    <p class='item white font-montserrat overflow'>${item.label}</p>
                </a>
            `)
        })
	})

    $("#case-available-items > div").sort((a,b) => Number(a.id.split("-")[0]) - Number(b.id.split("-")[0])).each(function () {
        $(this).remove();
        $(this).appendTo("#case-available-items");
    });

	for (let i = 0; i < 125; i++) {
		const item = allItems[Math.floor(Math.random() * allItems.length)]

		const chestElem = `
            <div class='case-roll-item-wrapper' draggable='false'>
                <div class='case-roll-item'>
                    <img class='icon' src='assets/img/${item.image}' alt='item-drop' draggable='false'>
                    <p class='item white font-montserrat overflow ${item.variety}'>${item.label}</p>
                </div>
            </div>
        `

		if (i == 117) {
			$(chestElem).attr("id", "win").appendTo(`#case-roll-items`)
		}

		$(`#case-roll-items`).append(chestElem)
	}
}

start.back = function() {
    $("#case-opening").fadeOut('fast').empty()
    setTimeout(() => {
        $("#main-wrapper").fadeIn('fast')
    }, 400)
}

start.opening = function (caseType, caseId) {
	const caseIdInt = parseInt(caseId)
    start.sound('open', 1.0)

	axios.post(`https://wingg-cases/openCase`, {
        caseType: caseType,
        caseId: caseIdInt,
    }).then((tmp) => {
        const res = tmp.data

        if (!res.canBuy) {
            $("#open-case").effect("shake")
            return
        }

        lib.updateCoins(res.coins)

        setTimeout(() => {
            $("#case-roll-items").css("margin-left", `-${18798 - lib.mathrandom(-10, -120)}px`)
        }, 500)

        let btm = $("#back-to-main")
        btm.prop("disabled", true)
        btm.fadeOut("fast", () => {
            btm.css("opacity", "0")
        })

        let chest = lib.config[caseType][caseIdInt]
        let item = chest.drop[res.rareType][res.itemId]
        
        $("#open-case").fadeOut('fast', function(){
            $(this).remove()
        })
        $("#case-roll-items").css("transition", "all 6s cubic-bezier(.08,.6,0,1)")

        $("#win").html(`
            <div class='case-roll-item'>
                <img class='icon' src='assets/img/${item.image}' alt='item-drop' draggable='false'>
                <p id="win-label" class='item white font-montserrat ${res.rareType}'>${item.label}</p>
            </div>
        `)

        lib.isOpening = true

        setTimeout(() => {
            const css = {
                ".case-roll-wrapper": {
                    "transition": ".3s",
                    "width": "475px",
                },
                "#case-roll-items": {
                    "transition": "all .7s",
                    "margin-left": "-18872px",
                },
                ".case-roll-arrow": {
                    "opacity": "0",
                },
                ".case-roll-item-wrapper": {
                    "opacity": "0",
                },
                "#win": {
                    "border-right": "0",
                },
                "#win-label": {
                    "max-width": "unset"
                },
            }

            for (const [k, v] of Object.entries(css)) {
                $(k).css(v);
            }

            $("#case-btns").html(`
                <button id='claim-item' claim='true' class='case-btn'>
                    <p class='font-montserrat white'>ODBIERZ</p>
                </button>
                <button id='sell-item' claim='false' class='case-btn'>
                    <p class='font-montserrat white'>SPRZEDAJ ZA ${item.sellCredit} ${lib.currencies[caseType]}</p>
                </button>
            `);

            btm.prop("disabled", false);
            btm.attr("claim", "true");
            btm.fadeIn("fast", () => {
                btm.css("opacity", "1");
            });

            $("#claim-item, #sell-item, #back-to-main").click(function() {
                let getItem = $(this).attr("claim") === "true"

                axios.post(`https://wingg-cases/getReward`, {
                    caseType: caseType,
                    caseId: caseIdInt,
                    rareType: res.rareType,
                    itemIteration: parseInt(res.itemId),
                    getItem: getItem
                }).then((claim) => {
                    lib.updateCoins(claim.data.coins)
                    lib.isOpening = false

                    start.sound(getItem ? 'claim' : 'sell', getItem ? 0.6 : 0.8)

                    $("#claim-item, #sell-item").fadeOut("fast", function(){
                        $(this).remove()
                    })
                    $("#case-opening").fadeOut('fast', function() {
                        load.opening(caseType, caseId)
                    })
                }).catch(() => {})
            })
        }, 6900)
    }).catch(() => {})
}

lib.mathrandom = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

lib.updateCoins = function(val) {
    for (const [k,v] of Object.entries(val)) {
		$(`#${k}-coins`).text(v);
	}
}

load.html = function() {
    if (lib.loaded) {
        return
    }

    lib.loaded = true // <a class="target" url='https://indrop.eu/s/clowns'>
	$("body").append(`
        <div id='h3h3'>
            <div>
                <div id='global-wrapper'>
                    <header class='nav-bar'>
                        <div class='nav-logo'>
                            <img src='./assets/img/src/logo.png' alt='wingg'>
                            <h1 class='font-montserrat white'>WinGG.eu</h1>
                        </div>
                        <div class='icons-bar'>
                            <ul class='list'>
                                <li>
                                    <a class="target"> 
                                        <div class='icon' style='-webkit-mask-image: url(assets/img/src/store.svg);'></div>
                                        <p class='title white font-montserrat'>SKLEP</p>
                                    </a>
                                </li>
                                <li>
                                    <a class="target" url='https://discord.gg/wingg'>
                                        <div class='icon' style='-webkit-mask-image: url(assets/img/src/discord.svg);'></div>
                                        <p class='title white font-montserrat'>DISCORD</p>
                                    </a>
                                </li>
                                <li>
                                    <a class="target">
                                        <div class='icon gold-bg' style='-webkit-mask-image: url(assets/img/src/coin.svg);'></div>
                                        <p class='title font-montserrat gold-color'>GC</p>
                                        <p class='title white font' id='gold-coins'>N/A</p>
                                    </a>
                                </li>
                                <li>
                                    <a>
                                        <div class='icon silver-bg' style='-webkit-mask-image: url(assets/img/src/coin.svg);'></div>
                                        <p class='title font-montserrat silver-color'>SC</p>
                                        <p class='title white font' id='silver-coins'>N/A</p>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </header>
                    <aside id='last-drops'></aside>
                    <section id='main-wrapper'>
                        <main>
                        <div class='banner'> +
                                <div class='timer'>
                                    <div class='block'>
                                        <b id='day'>00</b>
                                        <p>DNI</p>
                                    </div>
                                    <p>:</p>
                                    <div class='block'>
                                        <b id='hour'>00</b>
                                        <p>GODZ</p>
                                    </div>
                                    <p>:</p>
                                    <div class='block'>
                                        <b id='minute'>00</b>
                                        <p>MIN</p>
                                    </div>
                                    <p>:</p>
                                    <div class='block'>
                                        <b id='second'>00</b>
                                        <p>SEK</p>
                                    </div>
                                </div>
                             
                            
                            <div id='banner-cases'></div>
                            </div>
                            <div class='container'>
                                <div class='content'>
                                    <div class='title'>
                                        <b></b>
                                        <div class='title-wrap'>
                                            <div class='box'>
                                                <p class='title font-exo gold-color'>GC</p>
                                            </div>
                                            <h2 class='font-montserrat white'>PREMIUM</h2>
                                        </div>
                                        <span></span>
                                    </div>
                                    <div id='premium-cases' class='cases-list'></div>
                                </div>
                                <div class='content'>
                                    <div class='title'>
                                        <b></b>
                                        <div class='title-wrap'>
                                            <div class='box'>
                                                <p class='title font-exo silver-color'>SC</p>
                                            </div>
                                            <h2 class='font-montserrat white'>NON PREMIUM</h2>
                                        </div>
                                        <span></span>
                                    </div>
                                    <div id='nonPremium-cases' class='cases-list'></div>
                                </div>
                            </div>
                        </main>
                    </section>
                    <section id='case-opening'></section>
                </div>
            </div>
            <footer>
                <h1 class='footer font-montserrat'>Copyright &copy; 2024 All rights reserved.</h1>
            </footer>
        </div>
    `)

    $(".target").click(function(){
        window.invokeNative("openUrl", $(this).attr('url'));
    })

	load.scroll()
	load.countdown()
}

load.scroll = function() {
	let cursordown = !1,
		cursorypos = 0,
		cursorxpos = 0
	$("#last-drops")
		.mousedown(function (o) {
			(cursordown = !0),
				(cursorxpos = $(this).scrollLeft() + o.clientX),
				(cursorypos = $(this).scrollTop() + o.clientY)
		})
		.mousemove(function (o) {
			if (cursordown) {
				try {
					$(this).scrollLeft(cursorxpos - o.clientX)
				} catch (s) {}
				try {
					$(this).scrollTop(cursorypos - o.clientY)
				} catch (r) {}
			}
		})
		.mouseup(
			(end = function (o) {
				cursordown = !1
			})
		)
		.mouseleave(end)
		.css("user-select", "none")
		.css("cursor", "grab")
}

load.countdown = function() {
	function pad(num) {
		return ("0" + parseInt(num)).substr(-2)
	}
	var countDownDate = new Date(config.date).getTime()

	setInterval(function() {
		var now = new Date().getTime()
		var distance = countDownDate - now

		$("#day").text(pad(Math.floor(distance / (1000 * 60 * 60 * 24))))
		$("#hour").text(pad(Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))))
		$("#minute").text(pad(Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60))))
		$("#second").text(pad(Math.floor((distance % (1000 * 60)) / 1000)))
	}, 1000)
}

$(document).on('keyup', function(res) {
    if (res.key == "Escape") {
        if (lib.isOpening) {
            return;
        }

        $("#h3h3").fadeOut('fast');
        axios.post(`https://wingg-cases/NUIFocusOff`, {}).catch(()=>{})
    }
})