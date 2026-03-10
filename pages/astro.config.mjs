// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import { readFileSync } from 'node:fs';
import rehypeExternalLinks from 'rehype-external-links';

const purusGrammar = JSON.parse(
  readFileSync(new URL('../extension/syntaxes/purus.tmLanguage.json', import.meta.url), 'utf-8')
);
purusGrammar.name = 'purus';

// https://astro.build/config
export default defineConfig({
  site: 'https://purus.work',
  outDir: '../docs',
  markdown: {
    rehypePlugins: [
      [rehypeExternalLinks, { target: '_blank', rel: ['noopener', 'noreferrer'] }],
    ],
  },
  integrations: [
    starlight({
      title: 'Purus',
      expressiveCode: {
        shiki: {
          langs: [purusGrammar],
        },
      },
      logo: {
        src: './src/assets/icon.png',
      },
      head: [
        {
          tag: 'meta',
          attrs: { property: 'og:type', content: 'website' },
        },
        {
          tag: 'meta',
          attrs: { property: 'og:site_name', content: 'Purus' },
        },
        {
          tag: 'meta',
          attrs: { property: 'og:image', content: 'https://purus.work/img/banner.png' },
        },
        {
          tag: 'meta',
          attrs: { name: 'twitter:card', content: 'summary_large_image' },
        },
        {
          tag: 'meta',
          attrs: { name: 'twitter:image', content: 'https://purus.work/img/banner.png' },
        },
      ],
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/otoneko1102/purus' },
      ],
      editLink: {
        baseUrl: 'https://github.com/otoneko1102/purus/edit/main/pages/',
      },
      defaultLocale: 'root',
      locales: {
        root: { label: 'English', lang: 'en' },
        ja: { label: '日本語', lang: 'ja' },
      },
      sidebar: [
        {
          label: 'Getting Started',
          translations: { ja: 'はじめに' },
          autogenerate: { directory: 'getting-started' },
        },
        {
          label: 'Language Reference',
          translations: { ja: '言語リファレンス' },
          autogenerate: { directory: 'reference' },
        },
        {
          label: 'Tools',
          translations: { ja: 'ツール' },
          autogenerate: { directory: 'tools' },
        },
        {
          label: 'Community',
          translations: { ja: 'コミュニティ' },
          items: [
            { label: 'Community Projects', translations: { ja: 'コミュニティプロジェクト' }, slug: 'community-projects' },
          ],
        },
        {
          label: 'Resources',
          translations: { ja: 'リソース' },
          items: [
            { label: 'RFC', link: 'https://github.com/otoneko1102/purus/blob/main/RFC.md', attrs: { target: '_blank' } },
            { label: 'Changelog', translations: { ja: '変更履歴' }, link: 'https://github.com/otoneko1102/purus/blob/main/CHANGELOG.md', attrs: { target: '_blank' } },
          ],
        },
      ],
    }),
  ],
});
