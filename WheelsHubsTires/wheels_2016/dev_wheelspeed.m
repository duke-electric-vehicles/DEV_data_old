Data=load('Analysis.txt');

t=Data(:,1); x=Data(:,2);
window=50;
for k=1:(numel(x)-window)
    v(k)=(x(k)-x(k+window))/(t(k+window)-t(k));
end
for k=1:numel(v)
    a(k)=(v(k)-v(k+1)/(t(k+window)-t(k));
end
