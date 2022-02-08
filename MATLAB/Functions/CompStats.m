function  CompStats(lab,tbl)
recall = zeros(height(lab), 1);
precision = zeros(height(lab), 1);
f1_score = zeros(height(lab), 1);
rec_prec_f1 = zeros(3,height(lab));

for i=1:length(tbl)
    % calculating recall:
    % c(i,i) divided by the sum(i-th row)
    rec_prec_f1(1,i)= tbl(i,i)/sum(tbl(i,:));
    % calculating precision
    % c(i,i) divided by the sum(i-th column)
    rec_prec_f1(2,i)= tbl(i,i)/sum(tbl(:,i));
end
rec_prec_f1(3,:) = 2*rec_prec_f1(1,:).*rec_prec_f1(2,:)./(rec_prec_f1(1,:) + rec_prec_f1(2,:));
fprintf('Class Names');
lab(:,1)'
for i=1:height(rec_prec_f1)
    if i==1
        fprintf('Recall');
        rec_prec_f1(i,:)
    elseif i==2
        fprintf('Precision');
        rec_prec_f1(i,:)
    else
        fprintf('F1 Score');
        rec_prec_f1(i,:)
    end
end
end