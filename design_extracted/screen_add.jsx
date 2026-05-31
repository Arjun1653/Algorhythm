/* screen_add.jsx — Add Problem: search-first catalog flow */

function Field({ label, children, hint }) {
  return (
    <div style={{ marginBottom: 20 }}>
      <div className="row" style={{ justifyContent: 'space-between', marginBottom: 10 }}>
        <span className="eyebrow">{label}</span>
        {hint && <span className="mono" style={{ fontSize: 10.5, color: 'var(--text-3)' }}>{hint}</span>}
      </div>
      {children}
    </div>
  );
}

function TextInput({ value, onChange, placeholder, icon, mono, autoFocus }) {
  return (
    <div className="row" style={{
      gap: 10, padding: '0 14px', height: 50,
      background: 'var(--surface-3)', border: '1px solid var(--border)', borderRadius: 14,
    }}>
      {icon && <span style={{ color: 'var(--text-3)', display: 'flex' }}>{icon}</span>}
      <input
        value={value}
        onChange={e => onChange(e.target.value)}
        placeholder={placeholder}
        autoFocus={autoFocus}
        style={{
          flex: 1, border: 'none', outline: 'none', background: 'transparent',
          color: 'var(--text-1)',
          fontFamily: mono ? 'var(--font-mono)' : 'var(--font-body)', fontSize: 14.5,
        }}
      />
    </div>
  );
}

function ChipPicker({ options, value, onChange, scroll }) {
  return (
    <div style={{ display: 'flex', flexWrap: scroll ? 'nowrap' : 'wrap', gap: 8, overflowX: scroll ? 'auto' : 'visible' }} className="heatscroll">
      {options.map(opt => {
        const on = value === opt;
        return (
          <button key={opt} className="tap" onClick={() => onChange(opt)} style={{
            flexShrink: 0, padding: '9px 14px', borderRadius: 12,
            fontFamily: 'var(--font-body)', fontWeight: 600, fontSize: 13,
            background: on ? 'var(--accent-soft)' : 'var(--surface-3)',
            color: on ? 'var(--accent)' : 'var(--text-2)',
            border: '1px solid ' + (on ? 'var(--accent-line)' : 'var(--border)'),
          }}>{opt}</button>
        );
      })}
    </div>
  );
}

function DifficultyPicker({ value, onChange }) {
  const opts = [
    { id: 'easy',   label: 'Easy',   color: 'var(--emerald)', soft: 'var(--emerald-soft)' },
    { id: 'medium', label: 'Medium', color: 'var(--amber)',   soft: 'var(--amber-soft)' },
    { id: 'hard',   label: 'Hard',   color: 'var(--red)',     soft: 'var(--red-soft)' },
  ];
  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>
      {opts.map(o => {
        const on = value === o.id;
        return (
          <button key={o.id} className="tap" onClick={() => onChange(o.id)} style={{
            padding: '12px 0', borderRadius: 14, textAlign: 'center',
            fontFamily: 'var(--font-display)', fontWeight: 600, fontSize: 14,
            background: on ? o.soft : 'var(--surface-3)',
            color: on ? o.color : 'var(--text-2)',
            border: '1.5px solid ' + (on ? 'color-mix(in oklch, ' + o.color + ' 35%, transparent)' : 'var(--border)'),
          }}>{o.label}</button>
        );
      })}
    </div>
  );
}

/* ── Source badge ─────────────────────────────────────────── */
function SourceBadge({ src }) {
  const colors = {
    'Striver A2Z':  { color: 'var(--accent)',  bg: 'var(--accent-soft)' },
    'NeetCode 150': { color: 'var(--emerald)', bg: 'var(--emerald-soft)' },
    'Blind 75':     { color: 'var(--amber)',   bg: 'var(--amber-soft)' },
    'Grind 75':     { color: 'var(--amber)',   bg: 'var(--amber-soft)' },
    'LC Top 150':   { color: 'var(--text-2)',  bg: 'var(--surface-3)' },
    'AlgoExpert':   { color: 'var(--text-2)',  bg: 'var(--surface-3)' },
    'Codeforces':   { color: 'var(--text-2)',  bg: 'var(--surface-3)' },
    'GFG Must-Do':  { color: 'var(--text-2)',  bg: 'var(--surface-3)' },
  };
  const c = colors[src] || { color: 'var(--text-3)', bg: 'var(--surface-3)' };
  return (
    <span className="mono" style={{
      fontSize: 10, fontWeight: 600, padding: '3px 7px', borderRadius: 7,
      color: c.color, background: c.bg,
    }}>{src}</span>
  );
}

/* ── Step 1: Search catalog ───────────────────────────────── */
function SearchStep({ onSelect, onManual }) {
  const [q, setQ] = React.useState('');

  const results = q.length >= 2
    ? CATALOG.filter(p =>
        p.name.toLowerCase().includes(q.toLowerCase()) ||
        p.topic.toLowerCase().includes(q.toLowerCase()) ||
        (p.patterns || []).some(pt => pt.toLowerCase().includes(q.toLowerCase()))
      ).slice(0, 8)
    : [];

  return (
    <div>
      {/* Search bar */}
      <div className="row" style={{
        gap: 10, padding: '0 14px', height: 52,
        background: 'var(--surface-3)', border: '1.5px solid var(--accent-line)', borderRadius: 16,
        marginBottom: 14,
      }}>
        <span style={{ color: 'var(--accent)', display: 'flex' }}><IconSearch size={20} /></span>
        <input
          autoFocus
          value={q}
          onChange={e => setQ(e.target.value)}
          placeholder="Search 900+ problems by name or topic…"
          style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            color: 'var(--text-1)', fontFamily: 'var(--font-body)', fontSize: 14.5,
          }}
        />
        {q && (
          <button className="tap" onClick={() => setQ('')} style={{ color: 'var(--text-3)', display: 'flex' }}>
            <IconClose size={18} />
          </button>
        )}
      </div>

      {/* Results */}
      {results.length > 0 && (
        <div>
          {results.map(p => (
            <button key={p.id} className="tap" onClick={() => onSelect(p)} style={{
              width: '100%', padding: '13px 16px', borderRadius: 14, textAlign: 'left',
              background: 'var(--surface-2)', border: '1px solid var(--border)',
              marginBottom: 8, color: 'var(--text-1)',
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div className="row" style={{ gap: 8, marginBottom: 7, flexWrap: 'wrap' }}>
                  <span className="disp" style={{
                    fontSize: 14.5, fontWeight: 600, letterSpacing: '-.2px',
                    overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
                  }}>{p.name}</span>
                </div>
                <div className="row" style={{ gap: 7, flexWrap: 'wrap' }}>
                  <Difficulty level={p.difficulty} />
                  <span className="mono" style={{
                    fontSize: 11, color: 'var(--text-2)',
                    padding: '3px 7px', background: 'var(--surface-3)', borderRadius: 7,
                  }}>{p.topic}</span>
                  <SourceBadge src={p.src} />
                </div>
              </div>
              <span style={{ color: 'var(--text-3)', display: 'flex', flexShrink: 0 }}>
                <IconArrowRight size={18} />
              </span>
            </button>
          ))}
        </div>
      )}

      {/* Empty / prompt state */}
      {q.length < 2 && (
        <div style={{ padding: '8px 0' }}>
          <div className="eyebrow" style={{ marginBottom: 10 }}>Sources included</div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 7 }}>
            {['Striver A2Z', 'NeetCode 150', 'Blind 75', 'Grind 75', 'LC Top 150', 'AlgoExpert', 'Codeforces', 'GFG Must-Do'].map(s => (
              <SourceBadge key={s} src={s} />
            ))}
          </div>
          <div className="mono" style={{ fontSize: 11.5, color: 'var(--text-3)', marginTop: 14, lineHeight: 1.6 }}>
            Type at least 2 characters to search. All metadata auto-fills on selection.
          </div>
        </div>
      )}

      {q.length >= 2 && results.length === 0 && (
        <div style={{ textAlign: 'center', padding: '20px 0' }}>
          <div className="mono" style={{ fontSize: 12.5, color: 'var(--text-3)', lineHeight: 1.6 }}>
            No match for "{q}". Log it manually below.
          </div>
        </div>
      )}

      {/* Manual entry CTA */}
      <button className="tap" onClick={onManual} style={{
        width: '100%', padding: '13px 16px', borderRadius: 14, marginTop: 8,
        background: 'transparent', border: '1px dashed var(--border-strong)',
        display: 'flex', alignItems: 'center', gap: 10, color: 'var(--text-2)',
      }}>
        <span style={{ display: 'flex' }}><IconPlus size={18} /></span>
        <div style={{ textAlign: 'left' }}>
          <div className="disp" style={{ fontSize: 14, fontWeight: 600 }}>Log manually</div>
          <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginTop: 2 }}>
            Not in catalog — enter details yourself
          </div>
        </div>
      </button>
    </div>
  );
}

/* ── Step 2: Confirm / fill in remaining fields ───────────── */
function ConfirmStep({ fromCatalog, initial, onClose, confMode }) {
  const [name, setName]         = React.useState(initial.name     || '');
  const [platform, setPlatform] = React.useState(initial.platform || 'LeetCode');
  const [difficulty, setDiff]   = React.useState(initial.difficulty || 'medium');
  const [topic, setTopic]       = React.useState(initial.topic    || TOPICS[0]);
  const [pattern, setPattern]   = React.useState((initial.patterns && initial.patterns[0]) || PATTERNS[0]);
  const [conf, setConf]         = React.useState(3);
  const [url, setUrl]           = React.useState(initial.url      || '');

  const confLabels = ['', 'Shaky', 'Learning', 'Comfortable', 'Confident', 'Mastered'];

  return (
    <div>
      {/* Auto-fill notice */}
      {fromCatalog && (
        <div style={{
          padding: '11px 14px', borderRadius: 12, marginBottom: 20,
          background: 'var(--emerald-soft)',
          border: '1px solid color-mix(in oklch, var(--emerald) 24%, transparent)',
          display: 'flex', alignItems: 'center', gap: 9,
        }}>
          <span style={{ color: 'var(--emerald)', display: 'flex', flexShrink: 0 }}><IconCheck size={16} sw={2.5} /></span>
          <div className="mono" style={{ fontSize: 11.5, color: 'var(--emerald)', lineHeight: 1.5 }}>
            Auto-filled from catalog. Just rate your confidence and you're done.
          </div>
        </div>
      )}

      <Field label="Problem name">
        <TextInput
          value={name} onChange={setName}
          placeholder="e.g. Group Anagrams"
        />
      </Field>

      <Field label="Platform">
        <ChipPicker options={PLATFORMS} value={platform} onChange={setPlatform} scroll />
      </Field>

      <Field label="Difficulty">
        <DifficultyPicker value={difficulty} onChange={setDiff} />
      </Field>

      <Field label="Topic">
        <ChipPicker options={TOPICS} value={topic} onChange={setTopic} scroll />
      </Field>

      <Field label="Pattern">
        <ChipPicker options={PATTERNS} value={pattern} onChange={setPattern} scroll />
      </Field>

      <Field label="Confidence" hint={confLabels[conf]}>
        <div className="row" style={{ justifyContent: 'space-between' }}>
          <Confidence value={conf} onChange={setConf} mode={confMode || 'stars'} size={30} gap={10} />
          <span className="disp" style={{ fontSize: 15, fontWeight: 700, color: 'var(--accent)' }}>{conf}/5</span>
        </div>
      </Field>

      <Field label="Link" hint="optional">
        <TextInput
          value={url} onChange={setUrl}
          placeholder="leetcode.com/problems/…"
          icon={<IconLink size={18} />} mono
        />
      </Field>

      <button className="tap" onClick={onClose} style={{
        width: '100%', height: 54, borderRadius: 17,
        background: 'var(--accent)', color: 'var(--on-accent)',
        fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 16,
        display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        marginTop: 4,
      }}>
        <IconCheck size={20} /> Log Problem
      </button>
    </div>
  );
}

/* ── Sheet root ───────────────────────────────────────────── */
function AddProblemSheet({ open, onClose, confMode }) {
  const [step, setStep]         = React.useState('search'); // 'search' | 'confirm'
  const [fromCatalog, setFrom]  = React.useState(false);
  const [initial, setInitial]   = React.useState({});

  const handleClose = () => {
    setStep('search');
    setFrom(false);
    setInitial({});
    onClose();
  };

  const handleSelect = (catalogItem) => {
    setInitial({
      name:       catalogItem.name,
      platform:   catalogItem.platform,
      difficulty: catalogItem.difficulty,
      topic:      catalogItem.topic,
      patterns:   catalogItem.patterns,
      url:        catalogItem.url,
    });
    setFrom(true);
    setStep('confirm');
  };

  const handleManual = () => {
    setInitial({});
    setFrom(false);
    setStep('confirm');
  };

  if (!open) return null;

  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 40 }}>
      {/* Backdrop */}
      <div onClick={handleClose} style={{
        position: 'absolute', inset: 0, background: 'rgba(0,0,0,.6)',
        animation: 'fadeIn .22s ease both',
      }} />

      {/* Sheet */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, maxHeight: '94%',
        background: 'var(--surface-1)', borderRadius: '28px 28px 0 0',
        border: '1px solid var(--border)', borderBottom: 'none',
        display: 'flex', flexDirection: 'column',
        animation: 'sheetIn .36s cubic-bezier(.22,.61,.36,1) both',
        boxShadow: '0 -20px 60px rgba(0,0,0,.5)',
      }}>
        {/* Handle + header */}
        <div style={{ padding: '12px 22px 0', flexShrink: 0 }}>
          <div style={{ width: 40, height: 5, borderRadius: 3, background: 'var(--border-strong)', margin: '0 auto 16px' }} />
          <div className="row" style={{ justifyContent: 'space-between', marginBottom: 4 }}>
            <div>
              <div className="eyebrow">
                {step === 'search' ? 'Search catalog' : 'New entry'}
              </div>
              <div className="disp" style={{ fontSize: 22, fontWeight: 700, letterSpacing: '-.6px', marginTop: 3 }}>
                {step === 'search' ? 'Find Problem' : 'Log a Problem'}
              </div>
            </div>
            <div className="row" style={{ gap: 8 }}>
              {step === 'confirm' && (
                <button className="tap" onClick={() => setStep('search')} style={{
                  width: 38, height: 38, borderRadius: 12, background: 'var(--surface-3)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-2)',
                }}>
                  <IconBack size={18} />
                </button>
              )}
              <button className="tap" onClick={handleClose} style={{
                width: 38, height: 38, borderRadius: 12, background: 'var(--surface-3)',
                display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-2)',
              }}>
                <IconClose size={18} />
              </button>
            </div>
          </div>
        </div>

        {/* Scroll body */}
        <div className="heatscroll" style={{ overflowY: 'auto', padding: '20px 22px 34px', flex: 1 }}>
          {step === 'search'
            ? <SearchStep onSelect={handleSelect} onManual={handleManual} />
            : <ConfirmStep fromCatalog={fromCatalog} initial={initial} onClose={handleClose} confMode={confMode} />
          }
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { AddProblemSheet });
