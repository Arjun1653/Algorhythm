/* app.jsx — AlgoRhythm root */

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "dark":     true,
  "confMode": "stars",
  "accent":   "#7C3AED"
}/*EDITMODE-END*/;

function useScale() {
  React.useEffect(() => {
    const W = 424, H = 896;
    const el = document.getElementById('scaler');
    const fit = () => {
      const s = Math.min((window.innerWidth - 32) / W, (window.innerHeight - 32) / H, 1.08);
      el.style.transform = `scale(${s})`;
    };
    fit();
    window.addEventListener('resize', fit);
    return () => window.removeEventListener('resize', fit);
  }, []);
}

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  useScale();

  /* ── Navigation state ─────────────────────────────────── */
  const [tab,    setTab]    = React.useState('home');   // bottom nav tab
  const [screen, setScreen] = React.useState('onboarding'); // overlay screen
  const [screenProps, setScreenProps] = React.useState({});
  const [sheet, setSheet]   = React.useState(false);

  // Reset viewport scroll on tab change
  React.useEffect(() => {
    const v = document.getElementById('viewport');
    if (v) v.scrollTop = 0;
  }, [tab, screen]);

  const theme = t.dark ? 'dark' : 'light';

  /* ── Navigation helpers ───────────────────────────────── */
  // Push an overlay screen (Review, Detail, Topic, Settings)
  const push = (name, props = {}) => {
    setScreen(name);
    setScreenProps(props);
  };
  // Pop back to main tab view
  const pop = () => {
    setScreen(null);
    setScreenProps({});
  };

  /* ── Tab screens ──────────────────────────────────────── */
  const TAB_SCREENS = {
    home:      () => <HomeScreen
                       onAdd={() => setSheet(true)}
                       onNav={setTab}
                       onReview={() => push('review')}
                     />,
    roadmap:   () => <RoadmapScreen
                       onTopicPress={(name) => push('topic', { topicName: name })}
                     />,
    log:       () => <LogScreen
                       onProblemPress={(p) => push('detail', { problem: p })}
                     />,
    analytics: () => <AnalyticsScreen />,
  };

  /* ── Overlay screens (no bottom nav) ──────────────────── */
  const OVERLAY_SCREENS = {
    onboarding: () => <OnboardingScreen onDone={pop} />,
    review:     () => <ReviewScreen     onBack={pop} />,
    detail:     () => <DetailScreen     onBack={pop} {...screenProps} />,
    topic:      () => <TopicScreen      onBack={pop} {...screenProps} />,
    settings:   () => <SettingsScreen   onBack={pop} tweaks={t} setTweak={setTweak} />,
  };

  const isOverlay = screen && OVERLAY_SCREENS[screen];
  const showNav   = !isOverlay;

  const TabScreen   = TAB_SCREENS[tab];
  const OverlayComp = isOverlay ? OVERLAY_SCREENS[screen] : null;

  return (
    <div id="scaler" style={{ transformOrigin: 'center center' }}>
      <div data-theme={theme} style={{ '--accent': t.accent }} className="phone">
        <StatusBar />

        <div className="viewport" id="viewport" key={isOverlay ? screen : tab}>
          {isOverlay ? OverlayComp() : TabScreen()}
        </div>

        {/* Bottom nav + FAB — hidden during overlay screens */}
        {showNav && (
          <BottomNav
            active={tab}
            onNav={setTab}
            onAdd={() => setSheet(true)}
            showFab={tab === 'log'}
          />
        )}

        {/* Settings icon — top-right, always visible except on onboarding */}
        {screen !== 'onboarding' && (
          <button
            className="tap"
            onClick={() => isOverlay && screen === 'settings' ? pop() : push('settings')}
            style={{
              position: 'absolute', top: 14, right: 20, zIndex: 30,
              width: 38, height: 38, borderRadius: 12,
              background: 'var(--surface-2)',
              border: '1px solid var(--border)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: screen === 'settings' ? 'var(--accent)' : 'var(--text-2)',
            }}
          >
            <IconSettings size={19} />
          </button>
        )}

        <div className="gesturebar"><div className="pill" /></div>

        {/* Add problem sheet — available from any tab screen */}
        <AddProblemSheet
          open={sheet}
          onClose={() => setSheet(false)}
          confMode={t.confMode}
        />
      </div>

      {/* Tweaks panel */}
      <TweaksPanel>
        <TweakSection label="Appearance" />
        <TweakToggle label="Dark mode"  value={t.dark}     onChange={(v) => setTweak('dark', v)} />
        <TweakColor  label="Accent"     value={t.accent}
          options={['#7C3AED', '#C026D3', '#14B8A6', '#F97316']}
          onChange={(v) => setTweak('accent', v)}
        />
        <TweakSection label="Components" />
        <TweakRadio  label="Confidence" value={t.confMode}
          options={['stars', 'dots']}
          onChange={(v) => setTweak('confMode', v)}
        />
        <TweakSection label="Jump to screen" />
        <TweakRadio  label="Tab"         value={isOverlay ? '_' : tab}
          options={['home', 'roadmap', 'log', 'analytics']}
          onChange={(v) => { pop(); setTab(v); }}
        />
        <TweakRadio  label="Overlay"     value={isOverlay ? screen : '_'}
          options={['onboarding', 'review', 'detail', 'topic', 'settings']}
          onChange={(v) => push(v)}
        />
      </TweaksPanel>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
