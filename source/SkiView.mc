using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Position as Position;
using Toybox.Activity as Activity;
using Toybox.Timer as Timer;

var timer;
var session = null;
var isShowSaveView = false;

class SkiView extends Ui.View {

	var hours;
	var minutes;
	var seconds;
	
	var hoursAsString = "";
	var minutesAsString = "";
	var secondsAsString = "";


    //! Load your resources here
    function onLayout(dc) {
        timer = new Timer.Timer();

        timer.start( method(:timerUpdatesUi), 1000, true );

    }
    
    function timerUpdatesUi()
    {
        Ui.requestUpdate();
    }


    //! Restore the state of the app and prepare the view to be shown
    //! We need to enable the location events for now so that we make sure GPS
    //! is on.
    function onShow() {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! Update the view
    function onUpdate(dc) {
        dc.clear();
        
        if(isShowSaveView){
        	showSaveView(dc);
        }else{
        	showCurrentSessionView(dc);
        }
    }

    function onPosition(info) {
    }
    

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }
    
    function showSaveView(dc) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	dc.drawText(20, 10, Gfx.FONT_SMALL, 
	                	"Duration: " + hours + ":" + minutes + ":" + seconds, 
                		Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 40, Gfx.FONT_SMALL, "Distance: " + Activity. getActivityInfo().elapsedDistance.toNumber() / 1000 + "km", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawLine(0, 80, dc.getWidth(), 80);
        dc.drawLine(80, 80, 80, dc.getHeight());
        
        dc.drawText(120, 100, Gfx.FONT_MEDIUM, "Save", Gfx.TEXT_JUSTIFY_LEFT);
        var rec_image = Ui.loadResource(Rez.Drawables.id_recycled);
        dc.drawBitmap(25, 100, rec_image);
    }

	function showCurrentSessionView(dc) {
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        if( Toybox has :ActivityRecording ) {
            // Draw the instructions
            dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_WHITE);

            if( ( session == null )) {
                dc.drawText(20, 10, Gfx.FONT_SMALL, "Press Enter to start", Gfx.TEXT_JUSTIFY_LEFT);
            }
            else if( ( session != null ) && ( session.isRecording() == false ) ) {
                dc.drawText(20, 10, Gfx.FONT_SMALL, "Press again to continue", Gfx.TEXT_JUSTIFY_LEFT);
               	dc.drawText(20, 40, Gfx.FONT_SMALL, "or Menu to save", Gfx.TEXT_JUSTIFY_LEFT);
            }
            else if((session != null ) && session.isRecording()) {
            	if (Activity.getActivityInfo().timerTime != null &&
            		Activity. getActivityInfo().maxSpeed != null && 
            		Activity. getActivityInfo().totalDescent != null){
            		hours = Activity.getActivityInfo().timerTime/1000/60/60;
            		if (hours < 10){hoursAsString = "0" + hours;}else{ hoursAsString = hours;}
            		
            		minutes = Activity.getActivityInfo().timerTime/1000/60 - hours * 60;
            		if (minutes < 10){minutesAsString = "0" + minutes;}else{minutesAsString = minutes;}
            		
            		seconds = Activity.getActivityInfo().timerTime/1000 - hours * 60 - minutes * 60;
            		if (seconds < 10){secondsAsString = "0" + seconds;}else{secondsAsString = seconds;}
            		
                	dc.drawText(20, 10, Gfx.FONT_SMALL, 
	                	"Duration: "+ hoursAsString + ":" + minutesAsString + ":" + secondsAsString, 
                		Gfx.TEXT_JUSTIFY_LEFT);
                	dc.drawText(20, 40, Gfx.FONT_SMALL, "Max Speed: " + (Activity. getActivityInfo().maxSpeed/1000*3600).toNumber()  + " km/h", Gfx.TEXT_JUSTIFY_LEFT);
                	dc.drawText(20, 70, Gfx.FONT_SMALL, "Total Descent: " + Activity. getActivityInfo().totalDescent.toNumber() / 1000  + " km", Gfx.TEXT_JUSTIFY_LEFT);
                	}else{
                	dc.drawText(20, 10, Gfx.FONT_SMALL, "Not started yet", Gfx.TEXT_JUSTIFY_LEFT);
                	}
            }
        }
        // tell the user this app doesn't work
        else {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);
            dc.drawText(20, 20, Gfx.FONT_SMALL, "This product doesn't", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(25, 40, Gfx.FONT_SMALL, "have FIT Support", Gfx.TEXT_JUSTIFY_LEFT);
        }
	}	

}

