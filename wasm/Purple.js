function BonziLoader(voiceBox, canvasBox) {
    var ldr = {
        say: function say(sentence) {
            voiceBox.src = "https://api.birchy.dev/bonziProxy?say=" + sentence
            voiceBox.play()
            Module.push_event("s");
        },

        load: function init() {
            var spinner = document.getElementById('qtspinner');
            var canvas = canvasBox;

            var qtLoader = QtLoader({
                canvasElements : [canvas],
                showLoader: function(loaderStatus) {
                    spinner.style.display = 'flex';
                    canvas.style.display = 'none';
                },
                showError: function(errorText) {
                    spinner.style.display = 'flex';
                    canvas.style.display = 'none';
                    ldr.onError(errorText);
                },
                showExit: function() {
                    console.log('Exited with ' + qtLoader.exitCode);
                    console.log('Exit  text: ' + qtLoader.exitText);
                    spinner.style.display = 'flex';
                    canvas.style.display = 'none';
                    ldr.onExit();
                },
                showCanvas: function() {
                    spinner.style.display = 'none';
                    canvas.style.display = 'block';
                    voiceBox.addEventListener('ended', function() {
                      Module.push_event("e");
                    });
                    ldr.onLoaded();
                    setTimeout(ldr.onBonziArrived, 3000);
                },
            });
            
            qtLoader.loadEmscriptenModule("https://bonzi.birchy.dev/public/PurpleMonkeyFella");
        },

        onSentence: function(sentence) {},
        onError: function(err) { console.log(err); },
        onLoaded: function() {},
        onBonziArrived: function() {},
        onExit: function() {},
        enableRandom: function() {
            Module.push_event('rstart');
        },
        disableRandom: function() {
            Module.push_event('rstop');
        }
    };
    Module.popEvent = function(addr, len) {
        var str = '';
        var lastChar = 65;
        var i = 0;
        while(Module.HEAP8[addr + i] != 0) {
            lastChar = Module.HEAP8[addr + i++];
            str = str + String.fromCharCode(lastChar);
        }
        ldr.onSentence(str);
    };

    return ldr;
}
