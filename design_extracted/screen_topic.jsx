/* screen_topic.jsx — Topic detail: Cheatsheet + Problems */

/* ── Cheatsheet tab ───────────────────────────────────────── */
function ConceptCard({ text }) {
  return (
    <div className="card" style={{ padding: '18px 20px', marginBottom: 14 }}>
      <div className="eyebrow" style={{ marginBottom: 10 }}>Concept</div>
      <div style={{ fontSize: 13.5, color: 'var(--text-1)', lineHeight: 1.72 }}>{text}</div>
    </div>
  );
}

function PatternsCard({ patterns }) {
  return (
    <div className="card" style={{ padding: '18px 20px', marginBottom: 14 }}>
      <div className="eyebrow" style={{ marginBottom: 14 }}>Key Patterns</div>
      {patterns.map((p, i) => (
        <div key={i} style={{
          display: 'flex', gap: 12, marginBottom: i < patterns.length - 1 ? 14 : 0,
          paddingBottom: i < patterns.length - 1 ? 14 : 0,
          borderBottom: i < patterns.length - 1 ? '1px solid var(--border)' : 'none',
        }}>
          <div style={{
            width: 8, height: 8, borderRadius: '50%', flexShrink: 0,
            background: 'var(--accent)', marginTop: 5,
            boxShadow: '0 0 0 3px var(--accent-soft)',
          }} />
          <div>
            <div className="disp" style={{ fontSize: 14, fontWeight: 600 }}>{p.name}</div>
            <div className="mono" style={{ fontSize: 11.5, color: 'var(--text-2)', marginTop: 3, lineHeight: 1.5 }}>
              {p.cue}
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}

function ComplexityCard({ time, space, note }) {
  return (
    <div className="card" style={{ padding: '18px 20px', marginBottom: 14 }}>
      <div className="eyebrow" style={{ marginBottom: 14 }}>Complexity</div>
      <div style={{ display: 'flex', gap: 10, marginBottom: note ? 12 : 0 }}>
        {[{ label: 'Time', value: time }, { label: 'Space', value: space }].map(c => (
          <div key={c.label} style={{
            flex: 1, padding: '12px 14px', borderRadius: 14,
            background: 'var(--surface-3)', border: '1px solid var(--border)',
          }}>
            <div className="mono" style={{
              fontSize: 10, color: 'var(--text-3)',
              textTransform: 'uppercase', letterSpacing: '.6px',
            }}>{c.label}</div>
            <div className="mono" style={{ fontSize: 17, fontWeight: 600, color: 'var(--accent)', marginTop: 5 }}>
              {c.value}
            </div>
          </div>
        ))}
      </div>
      {note && (
        <div className="mono" style={{ fontSize: 11.5, color: 'var(--text-3)', lineHeight: 1.5 }}>
          ⓘ {note}
        </div>
      )}
    </div>
  );
}

function CodeCard({ snippet }) {
  return (
    <div className="card" style={{ padding: '18px 20px', marginBottom: 14 }}>
      <div className="eyebrow" style={{ marginBottom: 12 }}>Pattern snippet</div>
      <div style={{
        background: 'var(--surface-3)', borderRadius: 14, padding: '14px 16px',
        border: '1px solid var(--border)',
        overflowX: 'auto',
      }}>
        <pre className="mono" style={{
          margin: 0, fontSize: 12, lineHeight: 1.75,
          color: 'var(--text-1)', whiteSpace: 'pre', fontWeight: 500,
        }}>{snippet}</pre>
      </div>
    </div>
  );
}

function MistakesCard({ mistakes }) {
  return (
    <div className="card" style={{ padding: '18px 20px', marginBottom: 14 }}>
      <div className="eyebrow" style={{ marginBottom: 14 }}>Common mistakes</div>
      {mistakes.map((m, i) => (
        <div key={i} className="row" style={{
          gap: 10,
          marginBottom: i < mistakes.length - 1 ? 12 : 0,
        }}>
          <div style={{
            width: 20, height: 20, borderRadius: 7, flexShrink: 0,
            background: 'var(--red-soft)', color: 'var(--red)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 12, fontWeight: 700,
          }}>!</div>
          <span style={{ fontSize: 13, color: 'var(--text-1)', lineHeight: 1.55 }}>{m}</span>
        </div>
      ))}
    </div>
  );
}

function CheatsheetTab({ topicName }) {
  const data = CHEATSHEETS[topicName];
  if (!data) {
    return (
      <div style={{ textAlign: 'center', padding: '60px 20px' }}>
        <div className="mono" style={{ fontSize: 13, color: 'var(--text-3)' }}>
          Cheatsheet coming soon for this topic.
        </div>
      </div>
    );
  }
  return (
    <div>
      <ConceptCard text={data.concept} />
      <PatternsCard patterns={data.patterns} />
      <ComplexityCard time={data.timeComplexity} space={data.spaceComplexity} note={data.complexityNote} />
      <CodeCard snippet={data.snippet} />
      <MistakesCard mistakes={data.mistakes} />
    </div>
  );
}

/* ── Problems tab ─────────────────────────────────────────── */
function TopicProblemsTab({ topicName }) {
  const problems = PROBLEMS.filter(p => p.topic === topicName);
  if (!problems.length) {
    return (
      <div style={{ textAlign: 'center', padding: '60px 20px' }}>
        <div className="mono" style={{ fontSize: 13, color: 'var(--text-3)', lineHeight: 1.7 }}>
          No problems logged yet for this topic.{'\n'}
          Start solving and log them here.
        </div>
      </div>
    );
  }
  const STATUS_META = {
    solved:    { label: 'Solved',  color: 'var(--emerald)' },
    review:    { label: 'Review',  color: 'var(--amber)' },
    attempted: { label: 'Retry',   color: 'var(--text-3)' },
    unsolved:  { label: 'Not yet', color: 'var(--text-3)' },
  };
  return (
    <div>
      {problems.map(p => {
        const s = STATUS_META[p.status] || STATUS_META.unsolved;
        return (
          <div key={p.id} className="card tap" style={{ padding: '14px 16px', marginBottom: 10, cursor: 'pointer' }}>
            <div className="row" style={{ gap: 12 }}>
              <div style={{
                width: 8, height: 8, borderRadius: '50%', flexShrink: 0,
                background: s.color, marginTop: 7, alignSelf: 'flex-start',
                boxShadow: '0 0 0 4px color-mix(in oklch, ' + s.color + ' 16%, transparent)',
              }} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div className="row" style={{ justifyContent: 'space-between', gap: 8 }}>
                  <span className="disp" style={{
                    fontSize: 14.5, fontWeight: 600, letterSpacing: '-.2px',
                    overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
                  }}>{p.name}</span>
                  <span className="mono" style={{ fontSize: 11, color: s.color, fontWeight: 600, flexShrink: 0 }}>
                    {s.label}
                  </span>
                </div>
                <div className="row" style={{ gap: 8, marginTop: 9, flexWrap: 'wrap' }}>
                  <Difficulty level={p.difficulty} />
                  <span className="mono" style={{ fontSize: 11, color: 'var(--text-3)' }}>{p.pattern}</span>
                  {p.time && (
                    <span className="mono" style={{
                      fontSize: 11, color: 'var(--text-3)', marginLeft: 'auto',
                    }}>{p.time}</span>
                  )}
                </div>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}

/* ── Tab bar ──────────────────────────────────────────────── */
function TabBar({ tabs, active, onChange }) {
  return (
    <div style={{
      display: 'flex', gap: 4, padding: '4px',
      background: 'var(--surface-2)', border: '1px solid var(--border)',
      borderRadius: 16, marginBottom: 20,
    }}>
      {tabs.map(tab => {
        const on = active === tab.id;
        return (
          <button key={tab.id} className="tap" onClick={() => onChange(tab.id)} style={{
            flex: 1, padding: '9px 0', borderRadius: 12,
            fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600,
            background: on ? 'var(--surface-3)' : 'transparent',
            color: on ? 'var(--text-1)' : 'var(--text-3)',
            border: on ? '1px solid var(--border)' : '1px solid transparent',
            transition: 'all .18s ease',
          }}>{tab.label}</button>
        );
      })}
    </div>
  );
}

/* ── Screen root ──────────────────────────────────────────── */
function TopicScreen({ topicName = 'Arrays & Hashing', onBack }) {
  const [tab, setTab] = React.useState('cheatsheet');

  const topicData = ROADMAP.find(t => t.name === topicName) || { solved: 0, total: 0 };
  const pct = topicData.total > 0 ? Math.round((topicData.solved / topicData.total) * 100) : 0;

  return (
    <div style={{ position: 'relative', height: '100%' }}>
      <div className="screen animate-in" style={{ paddingTop: 10 }}>

        {/* Top bar */}
        <div className="row" style={{ gap: 12, padding: '4px 2px 18px' }}>
          <button className="tap" onClick={onBack} style={{
            width: 38, height: 38, borderRadius: 12, flexShrink: 0,
            background: 'var(--surface-2)', border: '1px solid var(--border)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-2)',
          }}>
            <IconBack size={20} />
          </button>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div className="eyebrow">Topic</div>
            <div className="disp" style={{
              fontSize: 18, fontWeight: 700, letterSpacing: '-.4px', marginTop: 2,
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>{topicName}</div>
          </div>
        </div>

        {/* Progress bar */}
        {topicData.total > 0 && (
          <div className="card" style={{ padding: '14px 18px', marginBottom: 18 }}>
            <div className="row" style={{ justifyContent: 'space-between', marginBottom: 10 }}>
              <span className="mono" style={{ fontSize: 11.5, color: 'var(--text-2)', fontWeight: 500 }}>
                {topicData.solved} / {topicData.total} problems solved
              </span>
              <span className="mono" style={{ fontSize: 12, fontWeight: 700, color: pct === 100 ? 'var(--emerald)' : 'var(--accent)' }}>
                {pct}%
              </span>
            </div>
            <Progress pct={pct} color={pct === 100 ? 'var(--emerald)' : 'var(--accent)'} h={7} />
          </div>
        )}

        {/* Tab bar */}
        <TabBar
          tabs={[{ id: 'cheatsheet', label: 'Cheatsheet' }, { id: 'problems', label: 'My Problems' }]}
          active={tab}
          onChange={setTab}
        />

        {/* Tab content */}
        <div className="animate-in" key={tab}>
          {tab === 'cheatsheet'
            ? <CheatsheetTab topicName={topicName} />
            : <TopicProblemsTab topicName={topicName} />
          }
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { TopicScreen });
