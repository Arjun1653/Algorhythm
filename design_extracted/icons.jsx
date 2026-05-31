/* icons.jsx — line icon set (24x24, currentColor stroke) */
const Icon = ({ d, size = 24, sw = 1.8, fill = 'none', children, style, ...rest }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill}
       stroke="currentColor" strokeWidth={sw} strokeLinecap="round"
       strokeLinejoin="round" style={style} {...rest}>
    {d ? <path d={d} /> : children}
  </svg>
);

const IconFlame = (p) => (
  <Icon {...p} fill="currentColor" stroke="none">
    <path d="M12 2.2c.6 3 2.1 4.2 3.6 5.7 1.5 1.5 2.9 3.2 2.9 5.9A6.5 6.5 0 0 1 12 20.3a6.5 6.5 0 0 1-6.5-6.5c0-1.8.8-3.2 1.7-4 .2 1 .9 1.8 1.8 2 .1-2.4 1.1-4.3 3-6.1.4 1 .9 1.7 1.6 2.2.4-1.5-.3-3.2-.6-4.7l-.0-.0Z"/>
    <path d="M12 20.3a6.5 6.5 0 0 0 6.5-6.5" stroke="none"/>
  </Icon>
);
// inner flame highlight variant
const IconFlameSolid = ({ size = 24, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" style={style}>
    <path d="M12.5 2c.4 2.9 2 4.3 3.6 5.9 1.6 1.6 3 3.4 3 6.1A7 7 0 0 1 5 14c0-2 .9-3.5 2-4.4.1 1.1.9 2 1.9 2.3.1-2.7 1.2-4.8 3.3-6.8.3 1.1.8 1.9 1.5 2.5C14.2 6 13 4 12.5 2Z"
      fill="currentColor"/>
    <path d="M12 20a4 4 0 0 0 4-4c0-1.6-1-2.7-2-3.6-.4.7-1 1-1.7 1.1.1-1.6-.5-2.7-1.6-3.7-.6 1.7-1.7 2.4-2.4 3.6-.4.7-.6 1.5-.6 2.3a4 4 0 0 0 4.3 4.3Z"
      fill="#0D0D0D" opacity="0.0"/>
  </svg>
);

const IconHome = (p) => (
  <Icon {...p}><path d="M3.5 11.2 12 4l8.5 7.2"/><path d="M5.5 9.7V19a1 1 0 0 0 1 1H10v-5h4v5h3.5a1 1 0 0 0 1-1V9.7"/></Icon>
);
const IconRoadmap = (p) => (
  <Icon {...p}>
    <circle cx="6" cy="5.5" r="2.2"/><circle cx="18" cy="12" r="2.2"/><circle cx="6" cy="18.5" r="2.2"/>
    <path d="M8.2 5.5H13a3 3 0 0 1 3 3v1.3M15.8 12H11a3 3 0 0 0-3 3v1.2"/>
  </Icon>
);
const IconLog = (p) => (
  <Icon {...p}><path d="M8 6h11M8 12h11M8 18h11"/><path d="M4 6h.01M4 12h.01M4 18h.01"/></Icon>
);
const IconChart = (p) => (
  <Icon {...p}><path d="M4 19.5V4.5"/><path d="M4 19.5h16"/><rect x="7" y="11" width="3" height="6" rx="1"/><rect x="12.5" y="7" width="3" height="10" rx="1"/><rect x="18" y="13.5" width="3" height="3.5" rx="1" transform="translate(-1 0)"/></Icon>
);
const IconPlus = (p) => (<Icon {...p} sw={2.2}><path d="M12 5v14M5 12h14"/></Icon>);
const IconSearch = (p) => (<Icon {...p}><circle cx="11" cy="11" r="6.5"/><path d="m20 20-3.5-3.5"/></Icon>);
const IconChevron = (p) => (<Icon {...p}><path d="m9 5 7 7-7 7"/></Icon>);
const IconLock = (p) => (<Icon {...p}><rect x="5" y="11" width="14" height="9" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/></Icon>);
const IconCheck = (p) => (<Icon {...p} sw={2.2}><path d="M5 12.5 10 17.5 19.5 7"/></Icon>);
const IconStar = ({ size = 24, filled, sw = 1.8 }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={filled ? 'currentColor' : 'none'}
       stroke="currentColor" strokeWidth={sw} strokeLinejoin="round">
    <path d="M12 3.2l2.6 5.5 6 .8-4.4 4.2 1.1 6L12 17l-5.3 2.9 1.1-6L3.4 9.5l6-.8L12 3.2Z"/>
  </svg>
);
const IconLink = (p) => (<Icon {...p}><path d="M9 15l6-6"/><path d="M11 7l1-1a4 4 0 0 1 5.7 5.7l-1 1"/><path d="M13 17l-1 1a4 4 0 0 1-5.7-5.7l1-1"/></Icon>);
const IconClock = (p) => (<Icon {...p}><circle cx="12" cy="12" r="8.2"/><path d="M12 7.5V12l3 1.8"/></Icon>);
const IconBolt = (p) => (<Icon {...p} fill="currentColor" stroke="none"><path d="M13 2 4.5 13.2H11l-1 8.8L19.5 10H13l0-8Z"/></Icon>);
const IconTarget = (p) => (<Icon {...p}><circle cx="12" cy="12" r="8.2"/><circle cx="12" cy="12" r="4"/><circle cx="12" cy="12" r="0.6" fill="currentColor"/></Icon>);
const IconTrophy = (p) => (<Icon {...p}><path d="M7 4h10v4a5 5 0 0 1-10 0V4Z"/><path d="M7 5H4.5v1.5A3 3 0 0 0 7 9.4M17 5h2.5v1.5A3 3 0 0 1 17 9.4"/><path d="M12 13v3M9 20h6M10 20l.4-2.2h3.2L14 20"/></Icon>);
const IconArrowUp = (p) => (<Icon {...p}><path d="M12 19V6M6 11l6-6 6 6"/></Icon>);
const IconArrowRight = (p) => (<Icon {...p}><path d="M5 12h14M13 6l6 6-6 6"/></Icon>);
const IconClose = (p) => (<Icon {...p} sw={2}><path d="M6 6l12 12M18 6 6 18"/></Icon>);
const IconCalendar = (p) => (<Icon {...p}><rect x="4" y="5.5" width="16" height="15" rx="2.5"/><path d="M4 10h16M8 3.5v4M16 3.5v4"/></Icon>);
const IconLayers = (p) => (<Icon {...p}><path d="M12 3 3 8l9 5 9-5-9-5Z"/><path d="m3 13 9 5 9-5M3 8v8M21 8v8" opacity=".55"/></Icon>);
const IconWarn = (p) => (<Icon {...p}><path d="M12 4 2.8 20h18.4L12 4Z"/><path d="M12 10v4.5M12 17.6h.01"/></Icon>);
const IconWifi = ({ size = 16 }) => (
  <svg width={size} height={size} viewBox="0 0 16 16" fill="currentColor"><path d="M8 13.3.67 5.97a10.37 10.37 0 0 1 14.66 0L8 13.3Z"/></svg>
);
const IconCell = ({ size = 16 }) => (
  <svg width={size} height={size} viewBox="0 0 16 16" fill="currentColor"><path d="M14.67 14.67V1.33L1.33 14.67h13.34Z"/></svg>
);
const IconBattery = ({ size = 16 }) => (
  <svg width={size} height={size} viewBox="0 0 16 16" fill="currentColor"><rect x="3.75" y="2" width="8.5" height="13" rx="1.6"/><rect x="5.6" y=".9" width="4.8" height="2" rx=".6"/></svg>
);

const IconBack     = (p) => (<Icon {...p}><path d="m15 18-6-6 6-6"/></Icon>);
const IconEdit     = (p) => (<Icon {...p}><path d="M11 4H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5"/><path d="m14.5 3.5 3 3L10 14l-4 1 1-4 7.5-7.5Z"/></Icon>);
const IconTrash    = (p) => (<Icon {...p}><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></Icon>);
const IconRepeat   = (p) => (<Icon {...p}><path d="m17 2 4 4-4 4"/><path d="M3 11V9a4 4 0 0 1 4-4h14M7 22l-4-4 4-4"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></Icon>);
const IconSettings = (p) => (<Icon {...p}><circle cx="12" cy="12" r="3.2"/><path d="M12 2v2.2M12 19.8V22M2 12h2.2M19.8 12H22M4.9 4.9l1.6 1.6M17.5 17.5l1.6 1.6M19.1 4.9l-1.6 1.6M6.5 17.5l-1.6 1.6"/></Icon>);
const IconBell     = (p) => (<Icon {...p}><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></Icon>);
const IconNote     = (p) => (<Icon {...p}><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8Z"/><path d="M14 2v6h6M16 13H8M16 17H8M10 9H8"/></Icon>);
const IconSwap     = (p) => (<Icon {...p}><path d="M7 16V4m0 0L3 8m4-4 4 4M17 8v12m0 0 4-4m-4 4-4-4"/></Icon>);
const IconBookmark = (p) => (<Icon {...p}><path d="m19 21-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16Z"/></Icon>);

Object.assign(window, {
  Icon, IconFlame, IconFlameSolid, IconHome, IconRoadmap, IconLog, IconChart, IconPlus,
  IconSearch, IconChevron, IconLock, IconCheck, IconStar, IconLink, IconClock, IconBolt,
  IconTarget, IconTrophy, IconArrowUp, IconArrowRight, IconClose, IconCalendar, IconLayers,
  IconWarn, IconWifi, IconCell, IconBattery,
  IconBack, IconEdit, IconTrash, IconRepeat, IconSettings, IconBell, IconNote, IconSwap, IconBookmark,
});
