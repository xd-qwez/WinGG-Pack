const w = window;
const doc = document;

// the color codes example `i ~r~love~s~ donuts`
const codes = {
    "~r~": "red",
    "~b~": "#378cbf",
    "~g~": "green",
    "~y~": "yellow",
    "~p~": "purple",
    "~c~": "grey",
    "~m~": "#212121",
    "~u~": "black",
    "~o~": "orange"
}

w.addEventListener('message', (event) => {
    if (event.data.action === "show") {
        notification(event.data.message);
    } else
    if (event.data.action === "hide") { 
        doc.getElementById('notify').style.display = "none"
    }
});

const replaceColors = (str, obj) => {
    let strToReplace = str

    for (let id in obj) {
        strToReplace = strToReplace.replace(new RegExp(id, 'g'), obj[id])
    }

    return strToReplace
}

notification = (message) => {
    for (color in codes) {
        if (message.includes(color)) {
            let objArr = {};
            objArr[color] = `<span style="color: ${codes[color]}">`;
            objArr["~s~"] = "</span>";

            let newStr = replaceColors(message, objArr);

            message = newStr;
        }
    }

    doc.getElementById('notify').style.display = "block";
    doc.getElementById('Message').innerHTML = message

}
