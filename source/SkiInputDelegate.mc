using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.ActivityRecording as Record;

class SkiInputDelegate extends Ui.InputDelegate {

    function onKey(item) {
       
	if(item.getKey() == Ui.KEY_ENTER){
	         if( Toybox has :ActivityRecording ) {
            if( ( session == null ) || ( session.isRecording() == false ) ) {
                session = Record.createSession({:name=>"Ski", :sport=>Record.SPORT_ALPINE_SKIING});
                session.start();
                Ui.requestUpdate();
            }
            else if( ( session != null ) && session.isRecording() ) {
                var res = session.stop();
                Ui.requestUpdate();
            }
        }
	 }
	 
	 if(item.getKey() == Ui.KEY_MENU){
	 	if( ( session != null ) && ( session.isRecording() == false ) ) {
	 		isShowSaveView = true;
	 		session.save();
            session = null;
	 		Ui.requestUpdate();
	 	}
	 }
	
    }

}