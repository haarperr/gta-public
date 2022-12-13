import { trigger, query, style, animate, transition, animateChild, group, } from '@angular/animations';

export const slideInAnimation =
  trigger('routeAnimations', [
    transition('* <=> FilterPage', [
      // transition('* => *', [
        query(
          ':enter',
          [style({ opacity: 0 })],
          { optional: true }
        ),
        query(
          ':leave',
           [style({ opacity: 1 }), animate('0.3s', style({ opacity: 0 }))],
          { optional: true }
        ),
        query(
          ':enter',
          [style({ opacity: 0 }), animate('0s', style({ opacity: 1 }))],
          { optional: true }
        )
      ])
  ]);