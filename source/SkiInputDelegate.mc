using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class SkiInputDelegate extends Ui.InputDelegate {

    function onKey(item) {
        
            Sys.println(item);

    }

}