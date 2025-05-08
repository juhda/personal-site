import type { JSX } from 'preact/jsx-runtime';

import { socialLinks } from '../config/site';

interface Props extends JSX.HTMLAttributes<HTMLAnchorElement> {
  href: string;
  download?: boolean;
}

export default function ExternalLink({ href, download = false, children, ...props }: Props) {
  const isExternal = /^https?:\/\//.test(href) &&
    !(import.meta.env.SITE && href.startsWith(import.meta.env.SITE))
  const isDownload = download;
  const isNewTab = isExternal;
  const isProtected = isExternal || isDownload;

  // GoatCounter auto-event name
  let goatEvent: string | undefined;

  // If it's a download from a relative path
  if (isDownload && href.startsWith('/')) {
    const name = href.replace(/^\//, '').replace(/\.[a-z]+$/, '').replace(/\W+/g, '-');
    goatEvent = `${name}-download`;
  }

  // Otherwise match known social links
  if (!goatEvent) {
    for (const [key, value] of Object.entries(socialLinks)) {
      if (href === value) {
        goatEvent = `${key}-click`;
        break;
      }
    }
  }

  return (
    <a
      href={href}
      download={isDownload ? true : undefined}
      target={isNewTab ? '_blank' : undefined}
      rel={isProtected ? 'noopener noreferrer' : undefined}
      data-goatcounter-click={goatEvent}
      {...props}
    >
      {children}
      {isDownload && (
        <>
          <span aria-hidden="true">⬇</span>
          <span class="sr-only">Download link</span>
        </>
      )}
      {!isDownload && isExternal && (
        <>
          <span aria-hidden="true">↗</span>
          <span class="sr-only">External link opens in new tab</span>
        </>
      )}
    </a>
  );
}
