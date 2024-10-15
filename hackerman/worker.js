var worker;
var stackWorker;

function startWasi(elemId, workerFileName, workerImageNamePrefix, workerImageChunks) {
    const xterm = new Terminal({
        cols: window.innerWidth,
        rows: window.innerHeight
    });
    const fitAddon = new FitAddon.FitAddon();
    xterm.open(document.getElementById(elemId));
    const { master, slave } = openpty();
    var termios = slave.ioctl("TCGETS");
    termios.iflag &= ~(/*IGNBRK | BRKINT | PARMRK |*/ ISTRIP | INLCR | IGNCR | ICRNL | IXON);
    termios.oflag &= ~(OPOST);
    termios.lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    //termios.cflag &= ~(CSIZE | PARENB);
    //termios.cflag |= CS8;
    slave.ioctl("TCSETS", new Termios(termios.iflag, termios.oflag, termios.cflag, termios.lflag, termios.cc));
    xterm.loadAddon(master);
    xterm.loadAddon(fitAddon);

    fitAddon.proposeDimensions({
        cols: window.innerWidth,
        rows: window.innerHeight
    })
    fitAddon.fit();
    worker = new Worker(workerFileName);

    var nwStack;
    var netParam = getNetParam();
    if (!netParam || netParam.mode != 'none') {
        stackWorker = new Worker("./src/stack-worker.js");
        nwStack = newStack(worker, workerImageNamePrefix, workerImageChunks, stackWorker, location.href + "/src/c2w-net-proxy.wasm");
    }
    if (!nwStack) {
        worker.postMessage({type: "init", imagename: workerImageNamePrefix, chunks: workerImageChunks});
    }
    new TtyServer(slave).start(worker, nwStack);
}

function getNetParam() {
    var vars = location.search.substring(1).split('&');
    for (var i = 0; i < vars.length; i++) {
        var kv = vars[i].split('=');
        if (decodeURIComponent(kv[0]) == 'net') {
            return {
                mode: kv[1],
                param: kv[2],
            };
        }
    }
    return null;
}
