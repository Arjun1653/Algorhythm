/* screen_analytics.jsx — Analytics */

function masteryColor(pct) {
  if (pct >= 70) return 'var(--emerald)';
  if (pct >= 40) return 'var(--amber)';
  return 'var(--red)';
}

function ActivityCard() {
  const active = HEATMAP.filter(v => v > 0).length;
  const months = ['Jun', 'Aug', 'Oct', 'Dec', 'Feb', 'Apr'];
  return (
    <div className="card" style={{ padding: 18 }}>
      <div className="row" style={{ justifyContent: 'space-between', marginBottom: 16 }}>
        <div>
          <div className="disp" style={{ fontSize: 16, fontWeight: 600 }}>Activity</div>
          <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginTop: 3 }}>{active} active days · last 12 months</div>
        </div>
        <span style={{ color: 'var(--accent)', display: 'flex' }}><IconCalendar size={20} /></span>
      </div>

      <Heatmap cells={HEATMAP} cell={12} gap={3} />

      <div className="row" style={{ justifyContent: 'space-between', marginTop: 14 }}>
        <div style={{ display: 'flex', gap: 22 }}>
          {months.slice(0, 4).map(m => (
            <span key={m} className="mono" style={{ fontSize: 10, color: 'var(--text-3)' }}>{m}</span>
          ))}
        </div>
        <div className="row" style={{ gap: 5 }}>
          <span className="mono" style={{ fontSize: 10, color: 'var(--text-3)' }}>Less</span>
          {[0, 1, 2, 3].map(v => (
            <div key={v} style={{ width: 11, height: 11, borderRadius: 3, background: `var(--heat-${v})` }} />
          ))}
          <span className="mono" style={{ fontSize: 10, color: 'var(--text-3)' }}>More</span>
        </div>
      </div>
    </div>
  );
}

function MasteryBar({ m }) {
  const color = masteryColor(m.pct);
  return (
    <div style={{ marginBottom: 16 }}>
      <div className="row" style={{ justifyContent: 'space-between', marginBottom: 8 }}>
        <span className="disp" style={{ fontSize: 14, fontWeight: 600 }}>{m.name}</span>
        <span className="mono" style={{ fontSize: 12, fontWeight: 600, color }}>{m.pct}%</span>
      </div>
      <Progress pct={m.pct} color={color} h={7} />
    </div>
  );
}

function FocusCard({ m }) {
  const color = masteryColor(m.pct);
  return (
    <div className="tap" style={{
      padding: '14px 16px', borderRadius: 16, marginBottom: 10, cursor: 'pointer',
      background: 'color-mix(in oklch, ' + color + ' 9%, var(--surface-2))',
      border: '1px solid color-mix(in oklch, ' + color + ' 28%, transparent)',
      display: 'flex', alignItems: 'center', gap: 13,
    }}>
      <div style={{
        width: 40, height: 40, borderRadius: 13, flexShrink: 0,
        background: 'color-mix(in oklch, ' + color + ' 18%, transparent)', color,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <IconWarn size={20} />
      </div>
      <div style={{ flex: 1 }}>
        <div className="disp" style={{ fontSize: 14.5, fontWeight: 600 }}>{m.name}</div>
        <div className="mono" style={{ fontSize: 11, color: 'var(--text-2)', marginTop: 2 }}>
          {m.pct}% mastery · {m.pct < 30 ? 'needs focused practice' : 'review recommended'}
        </div>
      </div>
      <span style={{ color, display: 'flex' }}><IconArrowRight size={19} /></span>
    </div>
  );
}

function AnalyticsScreen() {
  const weak = MASTERY.filter(m => m.pct < 45);
  return (
    <div className="screen animate-in" style={{ paddingTop: 14 }}>
      <div style={{ padding: '0 2px 20px' }}>
        <div className="eyebrow">Insights</div>
        <div className="disp" style={{ fontSize: 28, fontWeight: 700, letterSpacing: '-.8px', marginTop: 4 }}>Analytics</div>
      </div>

      <ActivityCard />

      <div style={{ marginTop: 24 }}>
        <SectionLabel action={<span className="mono" style={{ fontSize: 11, color: 'var(--text-3)' }}>6 topics</span>}>Topic mastery</SectionLabel>
        <div className="card" style={{ padding: '18px 18px 4px' }}>
          {MASTERY.map(m => <MasteryBar key={m.name} m={m} />)}
        </div>
      </div>

      <div style={{ marginTop: 24 }}>
        <SectionLabel>Focus areas</SectionLabel>
        {weak.map(m => <FocusCard key={m.name} m={m} />)}
      </div>
    </div>
  );
}

Object.assign(window, { AnalyticsScreen });
