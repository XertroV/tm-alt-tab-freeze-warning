const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$f5d";
const string PluginIcon = Icons::Cogs;
const string MenuTitle = MenuIconColor + PluginIcon + "\\$z " + PluginName;

bool wasFocused = true;
bool currFocus = true;
bool isInPlayground;

void Main() {
    auto app = GetApp();
    auto inputPort = app.InputPort;
    while (true) {
        yield();
        currFocus = inputPort.IsFocused;
        isInPlayground = app.CurrentPlayground !is null;
        if (wasFocused != currFocus) {
            startnew(OnFocusChanged);
            wasFocused = currFocus;
        }
    }
}

uint lastOnFocusTime = 0;

void OnFocusChanged() {
    trace("Focus changed to: " + currFocus);
    if (currFocus) {
        lastOnFocusTime = Time::Now;
    } else {
    }
}

vec2 g_screen = vec2(2560, 1440);
void RenderEarly() {
    g_screen.x = Draw::GetWidth();
    g_screen.y = Draw::GetHeight();
}

[Setting category="General" name="Msg Time Length (ms)" min=1000 max=10000]
uint focusMsgTimeout = 5000;

[Setting category="General" name="Msg 1"]
string S_Msg1 = "Wait for lag!";


[Setting category="General" name="Font Size" min=10.0 max=300.0]
float S_FontSize = 50.0;

[Setting category="General" name="Msg 1 Location" min=0.0 max=1.0]
vec2 S_MsgWarning1Pos = vec2(.5, .5);
[Setting category="General" name="Msg 2 (Timer) Location" min=0.0 max=1.0]
vec2 S_MsgWarning2Pos = vec2(.5, .65);

[Setting category="General" name="Msg Color"]
vec4 S_Color = vec4(1, 0.4, 0.2, 1);


// 8:44
void Render() {
    if (!isInPlayground || Time::Now - lastOnFocusTime > focusMsgTimeout) {
        return;
    }
    _DrawFocusAlarm();
}

int f_Nvg_ExoExtraBoldItalic = nvg::LoadFont("Exo-ExtraBoldItalic.ttf", true, true);
float vScale = 1.0;

void _DrawFocusAlarm() {
    vScale = g_screen.y / 1440.;
    nvg::Reset();
    nvg::BeginPath();
    nvg::FontSize(S_FontSize * vScale);
    nvg::FontFace(f_Nvg_ExoExtraBoldItalic);
    nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);
    DrawTextWithStroke(S_MsgWarning1Pos * g_screen, S_Msg1, S_Color, 4.);
    DrawTextWithStroke(S_MsgWarning2Pos * g_screen, Time::Format(lastOnFocusTime + focusMsgTimeout - Time::Now), S_Color, 4.);
}
