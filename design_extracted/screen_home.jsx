/* screen_home.jsx — Home / Dashboard */

function StreakHero({ streak = 47 }) {
  // last 7 days: true = solved
  const week = [true, true, true, false, true, true, true];
  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  return (
    <div className="card" style={{ padding: '24px 22px 20px', position: 'relative', overflow: 'hidden' }}>
      <div style={{
        position: 'absolute', top: -70, right: -50, width: 200, height: 200,
        background: 'radial-gradient(circle, var(--accent-soft) 0%, transparent 70%)',
        pointerEvents: 'none',
      }} />
      <div className="row" style={{ gap: 16, position: 'relative' }}>
        <div style={{
          width: 64, height: 64, borderRadius: 20, flexShrink: 0,
          background: 'var(--accent-soft)', color: 'var(--accent)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <IconFlameSolid size={38} />
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
            <span className="disp" style={{ fontSize: 60, fontWeight: 700, lineHeight: .9, letterSpacing: '-2px' }}>{streak}</span>
            <span className="disp" style={{ fontSize: 17, fontWeight: 600, color: 'var(--text-2)' }}>days</span>
          </div>
          <div className="eyebrow" style={{ marginTop: 6 }}>Current streak · personal best 63</div>
        </div>
      </div>

      <div className="row" style={{ justifyContent: 'space-between', marginTop: 22, position: 'relative' }}>
        {week.map((on, i) => (
          <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 7 }}>
            <div style={{
              width: 30, height: 30, borderRadius: 11,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              background: on ? 'var(--accent)' : 'var(--surface-3)',
              color: on ? 'var(--on-accent)' : 'var(--text-3)',
            }}>
              {on ? <IconCheck size={16} /> : <span style={{ width: 5, height: 5, borderRadius: 9, background: 'currentColor' }} />}
            </div>
            <span className="mono" style={{ fontSize: 10, color: 'var(--text-3)', fontWeight: 500 }}>{days[i]}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function DailyChallenge({ onStart }) {
  return (
    <div className="card tap" onClick={onStart} style={{ padding: 18, marginTop: 14, cursor: 'pointer' }}>
      <div className="row" style={{ justifyContent: 'space-between', marginBottom: 14 }}>
        <span className="eyebrow" style={{ color: 'var(--accent)' }}>◆ Daily Challenge</span>
        <span className="mono" style={{ fontSize: 11, color: 'var(--text-3)' }}>resets in 6h</span>
      </div>
      <div className="row" style={{ gap: 14 }}>
        <div style={{ flex: 1 }}>
          <div className="disp" style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-.3px' }}>Trapping Rain Water</div>
          <div className="row" style={{ gap: 8, marginTop: 9 }}>
            <Difficulty level="hard" />
            <span className="mono" style={{ fontSize: 11, color: 'var(--text-2)' }}>Two Pointers</span>
          </div>
        </div>
        <button className="tap" style={{
          width: 46, height: 46, borderRadius: 15, flexShrink: 0,
          background: 'var(--accent)', color: 'var(--on-accent)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <IconBolt size={22} />
        </button>
      </div>
    </div>
  );
}

function ReviewBanner({ count = 5, onGo }) {
  return (
    <button className="tap" onClick={onGo} style={{
      width: '100%', marginTop: 14, padding: '15px 18px',
      display: 'flex', alignItems: 'center', gap: 14, textAlign: 'left',
      background: 'var(--amber-soft)', border: '1px solid color-mix(in oklch, var(--amber) 24%, transparent)',
      borderRadius: 18,
    }}>
      <div style={{
        width: 40, height: 40, borderRadius: 13, flexShrink: 0,
        background: 'color-mix(in oklch, var(--amber) 22%, transparent)', color: 'var(--amber)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <IconClock size={21} />
      </div>
      <div style={{ flex: 1 }}>
        <div className="disp" style={{ fontWeight: 600, fontSize: 15 }}>{count} problems due for review</div>
        <div style={{ fontSize: 12.5, color: 'var(--text-2)', marginTop: 1 }}>Spaced repetition keeps patterns sharp</div>
      </div>
      <span style={{ color: 'var(--amber)' }}><IconArrowRight size={20} /></span>
    </button>
  );
}

function QuickStats() {
  const stats = [
    { label: 'Solved', value: '184', Icon: IconCheck, tone: 'var(--emerald)' },
    { label: 'Streak', value: '47', Icon: IconFlame, tone: 'var(--accent)' },
    { label: 'Longest', value: '63', Icon: IconTrophy, tone: 'var(--amber)' },
  ];
  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10, marginTop: 14 }}>
      {stats.map((s) => (
        <div key={s.label} className="card" style={{ padding: '15px 14px' }}>
          <span style={{ color: s.tone, display: 'flex' }}><s.Icon size={19} /></span>
          <div className="disp" style={{ fontSize: 26, fontWeight: 700, marginTop: 10, letterSpacing: '-.5px' }}>{s.value}</div>
          <div className="mono" style={{ fontSize: 10.5, color: 'var(--text-3)', marginTop: 2, textTransform: 'uppercase', letterSpacing: '.6px' }}>{s.label}</div>
        </div>
      ))}
    </div>
  );
}

function HomeScreen({ onAdd, onNav }) {
  return (
    <div className="screen animate-in">
      <div className="row" style={{ justifyContent: 'space-between', padding: '14px 2px 18px' }}>
        <div>
          <div className="eyebrow">Wed · May 31</div>
          <div className="disp" style={{ fontSize: 24, fontWeight: 700, letterSpacing: '-.6px', marginTop: 3 }}>Good evening, Maya</div>
        </div>
        <div style={{
          width: 44, height: 44, borderRadius: 14,
          background: 'var(--surface-3)', border: '1px solid var(--border)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 16, color: 'var(--accent)',
        }}>MK</div>
      </div>

      <StreakHero streak={47} />
      <DailyChallenge onStart={onAdd} />
      <ReviewBanner count={5} onGo={() => onNav('log')} />

      <div style={{ marginTop: 22 }}>
        <SectionLabel>This week</SectionLabel>
        <QuickStats />
      </div>
    </div>
  );
}

Object.assign(window, { HomeScreen });
