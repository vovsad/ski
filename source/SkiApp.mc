using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class SkiApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
 
        return [ new SkiView(), new SkiInputDelegate() ];
    }

}

class SkiDelegate extends Ui.BehaviorDelegate {

    function onMenu() {
        if( Toybox has :ActivityRecording ) {
            if( ( session == null ) || ( session.isRecording() == false ) ) {
                session = Record.createSession({:name=>"Ski", :sport=>Record.SPORT_ALPINE_SKIING});
                session.start();
                Ui.requestUpdate();
            }
            else if( ( session != null ) && session.isRecording() ) {
                session.stop();
                session.save();
                session = null;
                Ui.requestUpdate();
            }
        }

    }

}