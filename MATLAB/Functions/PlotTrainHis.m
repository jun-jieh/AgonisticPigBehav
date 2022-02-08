function  PlotTrainHis(trainInfo)
combined_train_acc = trainInfo.TrainingAccuracy;
combined_train_loss =  trainInfo.TrainingLoss;
combined_test_acc = trainInfo.ValidationAccuracy;
combined_test_loss = trainInfo.ValidationLoss;

figure(1)
hold on;
TRNplt = plot(smoothdata(combined_train_acc/100,'gaussian',256),'LineWidth',2);
x = 1:length(combined_test_acc);
xs = x(~isnan(combined_test_acc));
ys = combined_test_acc(~isnan(combined_test_acc))/100;
TSTplt = plot(xs,ys,'LineWidth',2);
xlabel('Epochs', 'FontSize', 30)
ylabel('Accuracy', 'FontSize', 30)
ylim([0 1])
legend('Training','Testing','Reinitialization','Location','northeastoutside', 'FontSize', 24)
set(gca, 'XLim', [0,40000], 'XTick', 0:3750:37500,...
         'XTickLabel', 0:10:100, 'FontSize', 30);
end