import Link from './Link'

interface Props {
  icon?: string,
  title: string,
  message: string,
  ctaText?: string,
  ctaHref?: string
}

export default function EmptyState({
  icon,
  title,
  message,
  ctaText,
  ctaHref
}: Props) {
  return (
    <section class="text-center py-12">
      {icon && (
        <div class="text-4xl mb-4">{icon}</div>
      )}
      <h2>{title}</h2>
      <p>{message}</p>
      {ctaHref && ctaText && (
        <Link
          href={ctaHref}
          class="cta-button"
        >
          {ctaText}
        </Link>
      )}
    </section>
  );
}
