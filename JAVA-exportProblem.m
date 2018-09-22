fprintf( 'states\n\t' )
for s = 1:pRiver.nStates
    s2 = pRiver.states(s);
    pRiver.states(s).desc =  strcat( 'x', num2str(s2.aux2), 'y', num2str(s2.aux1));
    fprintf( pRiver.states(s).desc )
    if s ~= pRiver.nStates
        fprintf( ', ' );
    end
end
fprintf( '\nendstates' )
fprintf( '\n\n' )

%% Actions
pRiver.actions(1).desc =  'move-N';
pRiver.actions(2).desc =  'move-W';
pRiver.actions(3).desc =  'move-E';
pRiver.actions(4).desc =  'move-S';
pRiver.actions(5).desc =  'move-WAIT';
pRiver.actions(1).desc2 =  'UP';
pRiver.actions(2).desc2 =  'LEFT';
pRiver.actions(3).desc2 =  'RIGHT';
pRiver.actions(4).desc2 =  'DOWN';
pRiver.actions(5).desc2 =  'ERRO';

%% Ref
%1 - 'north'
%2 - West
%3 ' East
%4 - south


%% Actions
for act = 1:4
    fprintf( ['\naction move-', pRiver.actions(act).name{1} , '\n'  ] )

    for s = 1:pRiver.nStates
        s2 = pRiver.states(s);
        for ss = 1:pRiver.nStates
            ss2 = pRiver.states(ss);
            p = pRiver.transition(s, ss, act);
            if (p > 0.0)
                message  = ['\t', pRiver.states(s).desc, ' ' , pRiver.states(ss).desc, ' ' , num2str(p, '%6.4f' ), ' ' , num2str(p, '%6.4f' ), '\n' ];
                fprintf(message)
            end
        end
    end;
    fprintf( ['endaction'  , '\n'  ] )
end;

%% Actions2
for act = 1:4
    for s = 1:pRiver.nStates
        s2 = pRiver.states(s);
        for ss = 1:pRiver.nStates
            ss2 = pRiver.states(ss);
            p = pRiver.transition(s, ss, act);
            if (p > 0.0)
                message  = ['"(', num2str(pRiver.states(s).aux1), ',', num2str(pRiver.states(s).aux2), '), ', pRiver.actions(act).desc2, ', (' , num2str(pRiver.states(ss).aux1), ',', num2str(pRiver.states(ss).aux2), ')" = ' , num2str(p, '%6.4f' ), ' ', '\n' ];
                fprintf(message)
            end
        end
    end;
end;

%% Costs
fprintf( ['\ncost\n'])
for s = 1:pRiver.nStates
    if(pRiver.states(s).goal ~= 1)
        for a = 1:4
            s2 = pRiver.states(s);
            c = pRiver.reward2D(s, a);
            message  = ['\t', pRiver.states(s).desc, ' move-', pRiver.actions(a).name{1}, ' ' , num2str(c, '%6.4f' ), '\n' ];
            fprintf(message)
        end
    end
end;
fprintf( ['endcost'  , '\n'  ] )
%% Final

fprintf( ['\n'  , 'discount factor 1.0', '\n'  ] )

fprintf( ['\n'  , 'initialstate', '\n'  ] )
fprintf( ['\t', pRiver.states( length( pRiver.mapView)  ).desc ] )
fprintf( ['\n'  , 'endinitialstate', '\n'  ] )

fprintf( ['\n'  , 'goalstate', '\n'  ] )
fprintf( ['\t', pRiver.states( pRiver.goalStates  ).desc ] )
fprintf( ['\n'  , 'endgoalstate', '\n'  ] )
