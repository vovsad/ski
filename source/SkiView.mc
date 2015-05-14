using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Position as Position;
using Toybox.Activity as Activity;
using Toybox.Timer as Timer;

var timer;
var session = null;

class SkiView extends Ui.View {


    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        
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
        // Set background color
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        if( Toybox has :ActivityRecording ) {
            // Draw the instructions
            dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_WHITE);

            if( ( session == null ) || ( session.isRecording() == false ) ) {
                dc.drawText(20, 10, Gfx.FONT_SMALL, "Press Enter to start", Gfx.TEXT_JUSTIFY_LEFT);
            }
            else if( ( session != null ) && session.isRecording() ) {
            //Sys.print(Activity.getActivityInfo().timerTime);
            	if (Activity.getActivityInfo().timerTime != null){
            		var hours = Activity.getActivityInfo().timerTime/1000/60/60;
            		var minutes = Activity.getActivityInfo().timerTime/1000/60 - hours * 60;
            		var seconds = Activity.getActivityInfo().timerTime/1000 - hours * 60 - minutes * 60;
                	dc.drawText(20, 10, Gfx.FONT_SMALL, 
	                	"Duration: " + hours + ":" + minutes + ":" + seconds, 
                		Gfx.TEXT_JUSTIFY_LEFT);
                	dc.drawText(20, 50, Gfx.FONT_SMALL, "Max Speed: " + Activity. getActivityInfo().maxSpeed, Gfx.TEXT_JUSTIFY_LEFT);
                	dc.drawText(20, 90, Gfx.FONT_SMALL, "Total Descent: " + Activity. getActivityInfo().totalDescent, Gfx.TEXT_JUSTIFY_LEFT);
                	}else{
                	dc.drawText(20, 10, Gfx.FONT_SMALL, "Not started yet", Gfx.TEXT_JUSTIFY_LEFT);
                	}
            }
        }
        // tell the user this sample doesn't work
        else {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);
            dc.drawText(20, 20, Gfx.FONT_SMALL, "This product doesn't", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(25, 50, Gfx.FONT_SMALL, "have FIT Support", Gfx.TEXT_JUSTIFY_LEFT);
        }
    }

    function onPosition(info) {
    }
    

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

}