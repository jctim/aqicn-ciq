using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class AqicnMainView extends Ui.View {

    var dataLoader;
    var initialView;

    function initialize(dataLoader, initialView) {
        self.dataLoader = dataLoader;
        self.initialView = initialView;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }


    // Update the view
    function onUpdate(dc) {
        Sys.println("main view: status: " + dataLoader.status);
        Sys.println("main view: data:   " + dataLoader.data);

        if (dataLoader.status >= 10) {
            var bgView   = View.findDrawableById("MainBackground");
            var cityView = View.findDrawableById("CityValue");
            var aqiView  = View.findDrawableById("AqiValue");
            var pm25View = View.findDrawableById("Pm25Value");
            var pm10View = View.findDrawableById("Pm10Value");

            // it should be OkData, else fail
            var data = dataLoader.data;
            if (data.city != null) {
                cityView.setText(data.city.toString());
            }
            if (data.aqi != null) {
                aqiView.setText(data.aqi.toString());
            }
            if (data.pm25 != null) {
                pm25View.setText(data.pm25.toString());
            }
            if (data.pm10 != null) {
                pm10View.setText(data.pm10.toString());
            }
            bgView.setBgColor(decideColor(data.level));

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        } else {
            Ui.switchToView(initialView, null, Ui.SLIDE_IMMEDIATE);
        }
    }

    private function decideColor(level) {
        Sys.println("deciding color by level " + level);
        switch (level) {
            case Good: return Gfx.COLOR_DK_GREEN;
            case Moderate: return Gfx.COLOR_YELLOW;
            case UnhealthyForSensitive: return Gfx.COLOR_ORANGE;
            case Unhealthy: return Gfx.COLOR_RED;
            case VeryUnhealthy: return Gfx.COLOR_PURPLE;
            case Hazardous: return Gfx.COLOR_BLACK;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}

class AqicnMainViewDelegate extends Ui.InputDelegate {

    var data;

    function initialize(data) {
        self.data = data;
        Ui.InputDelegate.initialize();
    }

    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            showDetailsView();
        }
    }

    function onTap(evt) {
        if (evt.getType() == Ui.CLICK_TYPE_TAP) {
            showDetailsView();
        }
    }

    private function showDetailsView() {
        Ui.pushView(new AqicnDetailView(data.level), new AqicnDetailViewDelegate(), Ui.SLIDE_LEFT);
    }
}