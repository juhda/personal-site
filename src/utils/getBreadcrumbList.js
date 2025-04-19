export function getBreadcrumbList({ pathname, site, title }) {
  const segments = pathname
    .split('/')
    .filter(Boolean); // removes empty string from leading/trailing slashes

  const breadcrumb = [
    {
      "@type": "ListItem",
      position: 1,
      name: "Home",
      item: site
    }
  ];

  let cumulativePath = '';
  segments.forEach((segment, index) => {
    cumulativePath += `/${segment}`;
    const isLast = index === segments.length - 1;

    breadcrumb.push({
      "@type": "ListItem",
      position: index + 2,
      name: isLast ? title : capitalize(segment),
      item: new URL(cumulativePath, site).href
    });
  });

  return {
    "@type": "BreadcrumbList",
    "itemListElement": breadcrumb
  };
}

function capitalize(str) {
  return str
    .replace(/[-_]/g, ' ')
    .replace(/\b\w/g, (char) => char.toUpperCase());
}
