using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.ActivityRecording as Record;

class SkiInputDelegate extends Ui.InputDelegate {

    function onKey(item) {
    	Sys.print(item.getKey());
       
		if(item.getKey() == Ui.KEY_ENTER){
	        if( Toybox has :ActivityRecording ) {
            	if(session == null) {
                	session = Record.createSession({:name=>"Ski", :sport=>Record.SPORT_ALPINE_SKIING});
                	session.start();
                	Sys.print("Create");
            	}else if((session != null) && (session.isRecording() == false)) {
                	session.start();
                	Sys.print("Start");
                }else if(( session != null ) && session.isRecording()) {
	                var res = session.stop();
	                Sys.print("Stop");
    	        }
        	}
	 	}else if(item.getKey() == Ui.KEY_MENU){
	 		if(( session != null ) && ( session.isRecording() == false )) {
	 			isShowSaveView = true;
			}
	 	}else if(item.getKey() == Ui.KEY_ESC){
	 		isShowSaveView = false;
	 	}

		Ui.requestUpdate();
    }
    
    function onTap(item){
    	if(isShowSaveView){
	    	var tap = item.getCoordinates();
	    	if(tap[0] > 80 && tap[1] > 80){
	    		Sys.println("Do save");
	    		isShowSaveView = false;
		 		session.save();
	            session = null;
	    	}else if(tap[0] < 80 && tap[1] > 80){
	    		Sys.println("Do discard");
	    		isShowSaveView = false;
		 		session.discard();
	            session = null;
	    	}
	
	        Ui.requestUpdate();
		}
    }

}