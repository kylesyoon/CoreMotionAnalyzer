//
//  GraphViewController.m
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/2/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () <CPTPlotDelegate>
@property (weak, nonatomic) IBOutlet UIView *graphArea;
@property (weak, nonatomic) IBOutlet UIButton *userAccelerationButton;
@property (weak, nonatomic) IBOutlet UIButton *gravityButton;
@property (weak, nonatomic) IBOutlet UIButton *rotRateButton;

@property (nonatomic) BOOL showUserAccel;
@property (nonatomic) BOOL showGravity;
@property (nonatomic) BOOL showRotRate;

@property (strong, nonatomic) CPTGraph *graph;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showUserAccel = YES;
    self.showGravity = YES;
    self.showRotRate = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initPlot];
}

#pragma mark - Chart behavior

- (void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

- (void)configureHost
{
    self.hostView = [(CPTGraphHostingView *)[CPTGraphHostingView alloc] initWithFrame:self.graphArea.frame];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

- (void)configureGraph
{
    // 1. Create the graph.
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = self.graph;
    // 2. Set graph title.
    NSDictionary *firstObject = self.data.firstObject;
    CGFloat startTime = [firstObject[@"time"] floatValue];
    NSDictionary *lastObject = self.data.lastObject;
    CGFloat endTime = [lastObject[@"time"] floatValue];
    NSString *title = [NSString stringWithFormat:@"Motion Data for Time Frame %.2f - %.2f", startTime, endTime];
    self.graph.title = title;
    // 3. Create and set text style.
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Light";
    titleStyle.fontSize = 16.0f;
    self.graph.titleTextStyle = titleStyle;
    self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    self.graph.titleDisplacement = CGPointMake(0.0, 25.0);
//    // 4. Set padding for plot area.
//    [graph.plotAreaFrame setPaddingLeft:3.0];
//    [graph.plotAreaFrame setPaddingBottom:3.0];
    // 5. Enable user interactions for plot space.
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

- (void)configurePlots
{
    // Get graph and plot space.
    self.graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    // Create the three plots for each X, Y, Z.
    // Acceleration
    CPTScatterPlot *accelXPlot = [[CPTScatterPlot alloc] init];
    accelXPlot.dataSource = self;
    accelXPlot.identifier = @"ACCELX";
    CPTColor *accelXPlotColor = [CPTColor colorWithComponentRed:.643 green:.216 blue:.255 alpha:1.0];
    [self.graph addPlot:accelXPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *accelYPlot = [[CPTScatterPlot alloc] init];
    accelYPlot.dataSource = self;
    accelYPlot.identifier = @"ACCELY";
    CPTColor *accelYPlotColor = [CPTColor colorWithComponentRed:.463 green:.09 blue:.127 alpha:1.0];
    [self.graph addPlot:accelYPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *accelZPlot = [[CPTScatterPlot alloc] init];
    accelZPlot.dataSource = self;
    accelZPlot.identifier = @"ACCELZ";
    CPTColor *accelZPlotColor = [CPTColor colorWithComponentRed:.282 green:.016 blue:.039 alpha:1.0];
    [self.graph addPlot:accelZPlot toPlotSpace:plotSpace];
    // Gravity
    CPTScatterPlot *gravXPlot = [[CPTScatterPlot alloc] init];
    gravXPlot.dataSource = self;
    gravXPlot.identifier = @"GRAVX";
    CPTColor *gravXPlotColor = [CPTColor colorWithComponentRed:.357 green:.471 blue:.843 alpha:1.0];
    [self.graph addPlot:gravXPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *gravYPlot = [[CPTScatterPlot alloc] init];
    gravYPlot.dataSource = self;
    gravYPlot.identifier = @"GRAVY";
    CPTColor *gravYPlotColor = [CPTColor colorWithComponentRed:.184 green:.247 blue:.451 alpha:1.0];
    [self.graph addPlot:gravYPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *gravZPlot = [[CPTScatterPlot alloc] init];
    gravZPlot.dataSource = self;
    gravZPlot.identifier = @"GRAVZ";
    CPTColor *gravZPlotColor = [CPTColor colorWithComponentRed:.114 green:.153 blue:.278 alpha:1.0];
    [self.graph addPlot:gravZPlot toPlotSpace:plotSpace];
    // Rotation Rate
    CPTScatterPlot *rotXPlot = [[CPTScatterPlot alloc] init];
    rotXPlot.dataSource = self;
    rotXPlot.identifier = @"ROTX";
    CPTColor *rotXPlotColor = [CPTColor colorWithComponentRed:1.0 green:.925 blue:.114 alpha:1.0];
    [self.graph addPlot:rotXPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *rotYPlot = [[CPTScatterPlot alloc] init];
    rotYPlot.dataSource = self;
    rotYPlot.identifier = @"ROTY";
    CPTColor *rotYPlotColor = [CPTColor colorWithComponentRed:.847 green:.792 blue:.188 alpha:1.0];
    [self.graph addPlot:rotYPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *rotZPlot = [[CPTScatterPlot alloc] init];
    rotZPlot.dataSource = self;
    rotZPlot.identifier = @"ROTZ";
    CPTColor *rotZPlotColor = [CPTColor colorWithComponentRed:.486 green:.463 blue:.216 alpha:1.0];
    [self.graph addPlot:rotZPlot toPlotSpace:plotSpace];
    
    // Set up plot space.
    [plotSpace scaleToFitPlots:@[accelXPlot, accelYPlot, accelZPlot,
                                 gravXPlot, gravYPlot, gravZPlot,
                                 rotXPlot, rotYPlot, rotZPlot]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    
    // Create styles and symbols
    // Acceleration
    CPTMutableLineStyle *accelXLineStyle = [accelXPlot.dataLineStyle mutableCopy];
    accelXLineStyle.lineWidth = 2.5;
    accelXLineStyle.lineColor = accelXPlotColor;
    accelXPlot.dataLineStyle = accelXLineStyle;
    CPTMutableLineStyle *accelXSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    accelXSymbolLineStyle.lineColor = accelXPlotColor;
    CPTPlotSymbol *accelXSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    accelXSymbol.fill = [CPTFill fillWithColor:accelXPlotColor];
    accelXSymbol.lineStyle = accelXSymbolLineStyle;
    accelXSymbol.size = CGSizeMake(6.0f, 6.0f);
    accelXPlot.plotSymbol = accelXSymbol;
    
    CPTMutableLineStyle *accelYLineStyle = [accelYPlot.dataLineStyle mutableCopy];
    accelYLineStyle.lineWidth = 2.5;
    accelYLineStyle.lineColor = accelYPlotColor;
    accelYPlot.dataLineStyle = accelYLineStyle;
    CPTMutableLineStyle *accelYSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    accelYSymbolLineStyle.lineColor = accelYPlotColor;
    CPTPlotSymbol *accelYSymbol = [CPTPlotSymbol trianglePlotSymbol];
    accelYSymbol.fill = [CPTFill fillWithColor:accelYPlotColor];
    accelYSymbol.lineStyle = accelYSymbolLineStyle;
    accelYSymbol.size = CGSizeMake(6.0f, 6.0f);
    accelYPlot.plotSymbol = accelYSymbol;
    
    CPTMutableLineStyle *accelZLineStyle = [accelZPlot.dataLineStyle mutableCopy];
    accelZLineStyle.lineWidth = 2.5;
    accelZLineStyle.lineColor = accelZPlotColor;
    accelZPlot.dataLineStyle = accelZLineStyle;
    CPTMutableLineStyle *accelZSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    accelZSymbolLineStyle.lineColor = accelZPlotColor;
    CPTPlotSymbol *accelZSymbol = [CPTPlotSymbol starPlotSymbol];
    accelZSymbol.fill = [CPTFill fillWithColor:accelZPlotColor];
    accelZSymbol.lineStyle = accelZSymbolLineStyle;
    accelZSymbol.size = CGSizeMake(6.0f, 6.0f);
    accelZPlot.plotSymbol = accelZSymbol;
    // Gravity
    CPTMutableLineStyle *gravXLineStyle = [gravXPlot.dataLineStyle mutableCopy];
    gravXLineStyle.lineWidth = 2.5;
    gravXLineStyle.lineColor = gravXPlotColor;
    gravXPlot.dataLineStyle = gravXLineStyle;
    CPTMutableLineStyle *gravXSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    gravXSymbolLineStyle.lineColor = gravXPlotColor;
    CPTPlotSymbol *gravXSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    gravXSymbol.fill = [CPTFill fillWithColor:gravXPlotColor];
    gravXSymbol.lineStyle = gravXSymbolLineStyle;
    gravXSymbol.size = CGSizeMake(6.0f, 6.0f);
    gravXPlot.plotSymbol = gravXSymbol;
    
    CPTMutableLineStyle *gravYLineStyle = [gravYPlot.dataLineStyle mutableCopy];
    gravYLineStyle.lineWidth = 2.5;
    gravYLineStyle.lineColor = gravYPlotColor;
    gravYPlot.dataLineStyle = gravYLineStyle;
    CPTMutableLineStyle *gravYSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    gravYSymbolLineStyle.lineColor = gravYPlotColor;
    CPTPlotSymbol *gravYSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    gravYSymbol.fill = [CPTFill fillWithColor:gravXPlotColor];
    gravYSymbol.lineStyle = gravYSymbolLineStyle;
    gravYSymbol.size = CGSizeMake(6.0f, 6.0f);
    gravYPlot.plotSymbol = gravYSymbol;
    
    CPTMutableLineStyle *gravZLineStyle = [gravZPlot.dataLineStyle mutableCopy];
    gravZLineStyle.lineWidth = 2.5;
    gravZLineStyle.lineColor = gravZPlotColor;
    gravZPlot.dataLineStyle = gravZLineStyle;
    CPTMutableLineStyle *gravZSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    gravZSymbolLineStyle.lineColor = gravZPlotColor;
    CPTPlotSymbol *gravZSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    gravZSymbol.fill = [CPTFill fillWithColor:gravZPlotColor];
    gravZSymbol.lineStyle = gravZSymbolLineStyle;
    gravZSymbol.size = CGSizeMake(6.0f, 6.0f);
    gravZPlot.plotSymbol = gravZSymbol;
    // Rotation Rate
    CPTMutableLineStyle *rotXLineStyle = [rotXPlot.dataLineStyle mutableCopy];
    rotXLineStyle.lineWidth = 2.5;
    rotXLineStyle.lineColor = rotXPlotColor;
    rotXPlot.dataLineStyle = rotXLineStyle;
    CPTMutableLineStyle *rotXSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    rotXSymbolLineStyle.lineColor = rotXPlotColor;
    CPTPlotSymbol *rotXSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    rotXSymbol.fill = [CPTFill fillWithColor:rotXPlotColor];
    rotXSymbol.lineStyle = rotXSymbolLineStyle;
    rotXSymbol.size = CGSizeMake(6.0f, 6.0f);
    rotXPlot.plotSymbol = rotXSymbol;

    CPTMutableLineStyle *rotYLineStyle = [rotYPlot.dataLineStyle mutableCopy];
    rotYLineStyle.lineWidth = 2.5;
    rotYLineStyle.lineColor = rotYPlotColor;
    rotYPlot.dataLineStyle = rotYLineStyle;
    CPTMutableLineStyle *rotYSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    rotYSymbolLineStyle.lineColor = rotYPlotColor;
    CPTPlotSymbol *rotYSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    rotYSymbol.fill = [CPTFill fillWithColor:rotXPlotColor];
    rotYSymbol.lineStyle = rotYSymbolLineStyle;
    rotYSymbol.size = CGSizeMake(6.0f, 6.0f);
    rotYPlot.plotSymbol = rotYSymbol;
    
    CPTMutableLineStyle *rotZLineStyle = [rotZPlot.dataLineStyle mutableCopy];
    rotZLineStyle.lineWidth = 2.5;
    rotZLineStyle.lineColor = rotZPlotColor;
    rotZPlot.dataLineStyle = rotZLineStyle;
    CPTMutableLineStyle *rotZSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    rotZSymbolLineStyle.lineColor = rotZPlotColor;
    CPTPlotSymbol *rotZSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    rotZSymbol.fill = [CPTFill fillWithColor:rotXPlotColor];
    rotZSymbol.lineStyle = rotZSymbolLineStyle;
    rotZSymbol.size = CGSizeMake(6.0f, 6.0f);
    rotZPlot.plotSymbol = rotZSymbol;
}

- (void)configureAxes
{
    // Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 2.0;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0;
    // Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
    // Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Time";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;

    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:self.data.count];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:self.data.count];
    for (NSDictionary *motionData in self.data) {
        CGFloat time = [motionData[@"time"] floatValue];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%.2f", time] textStyle:x.labelTextStyle];
        label.tickLocation = CPTDecimalFromCGFloat(time);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:time]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    // Configure the y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Motion";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    CGFloat yMax = 400.0;  // TODO: Determine dynamically.
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (int i = -yMax; i <= yMax; i++) {
        CGFloat location = i / 10.0;
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%.1f", location] textStyle:y.labelTextStyle];
        label.tickLocation = CPTDecimalFromCGFloat(location);
        if (i % 5 == 0) {
            label.offset = -y.majorTickLength - y.labelOffset;
            [yMajorLocations addObject:[NSNumber numberWithFloat:location]];
        } else {
            label.offset = -y.minorTickLength - y.labelOffset;
            [yMinorLocations addObject:[NSNumber numberWithFloat:location]];
        }
        if (label) {
            [yLabels addObject:label];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.data.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSDictionary *motionData = [self.data objectAtIndex:idx];
    NSDictionary *accel = motionData[@"acceleration"];
    NSDictionary *grav = motionData[@"gravity"];
    NSDictionary *rot = motionData[@"rotation"];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (idx < self.data.count) {
                return motionData[@"time"];
            }
            break;
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:@"ACCELX"] == YES) {
                return accel[@"x"];
            } else if ([plot.identifier isEqual:@"ACCELY"] == YES) {
                return accel[@"y"];
            } else if ([plot.identifier isEqual:@"ACCELZ"] == YES) {
                return accel[@"z"];
            } else if ([plot.identifier isEqual:@"GRAVX"] == YES) {
                return grav[@"x"];
            } else if ([plot.identifier isEqual:@"GRAVY"] == YES) {
                return grav[@"y"];
            } else if ([plot.identifier isEqual:@"GRAVZ"] == YES) {
                return grav[@"z"];
            } else if ([plot.identifier isEqual:@"ROTX"] == YES) {
                return rot[@"x"];
            } else if ([plot.identifier isEqual:@"ROTY"] == YES) {
                return rot[@"y"];
            } else if ([plot.identifier isEqual:@"ROTZ"] == YES) {
                return rot[@"z"];
            }
            break;
    }
    return [NSDecimalNumber zero];
}

- (void)plot:(CPTPlot *)plot dataLabelTouchDownAtRecordIndex:(NSUInteger)idx
{
    CGFloat pointY = 0;
    NSDictionary *motionData = [self.data objectAtIndex:idx];
    if ([plot.identifier isEqual:@"ACCELX"] == YES) {
        NSDictionary *accel = motionData[@"acceleration"];
        pointY = [accel[@"x"] floatValue];
    }
    
    NSArray *anchor = @[motionData[@"time"], [NSNumber numberWithFloat:pointY]];
    
    CPTMutableTextStyle *annotationTextStyle = [CPTMutableTextStyle textStyle];
    annotationTextStyle.color = [CPTColor blackColor];
    annotationTextStyle.fontName = @"Helvetica-Light";
    annotationTextStyle.fontSize = 12.0;
    
    NSString *labelString = [NSString stringWithFormat:@"%.3f", pointY];
    //    NSArray *anchorPoint = @[[NSNumber numberWithFloat:point.x], [NSNumber numberWithFloat:point.y]];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:labelString style:annotationTextStyle];
    
    CPTPlotSpaceAnnotation *annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:(CPTXYPlotSpace *)self.graph.defaultPlotSpace  anchorPlotPoint:anchor];
    annotation.contentLayer = textLayer;
    annotation.displacement = CGPointMake(0.0f, 10.0f);
    [self.graph.plotAreaFrame.plotArea addAnnotation:annotation];
}

#pragma mark - Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - IBAction

- (IBAction)pressedClose
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }];
}

- (IBAction)pressedUserAccel:(UIButton *)button
{
    if (self.showUserAccel) {
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    }
    CPTPlot *accelX = [self.graph plotWithIdentifier:@"ACCELX"];
    accelX.hidden = !accelX.hidden;
    CPTPlot *accelY = [self.graph plotWithIdentifier:@"ACCELY"];
    accelY.hidden = !accelY.hidden;
    CPTPlot *accelZ = [self.graph plotWithIdentifier:@"ACCELZ"];
    accelZ.hidden = !accelZ.hidden;
    self.showUserAccel = !self.showUserAccel;
}

- (IBAction)pressedUserGravity:(UIButton *)button
{
    if (self.showGravity) {
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    }
    CPTPlot *gravX = [self.graph plotWithIdentifier:@"GRAVX"];
    gravX.hidden = !gravX.hidden;
    CPTPlot *gravY = [self.graph plotWithIdentifier:@"GRAVY"];
    gravY.hidden = !gravY.hidden;
    CPTPlot *gravZ = [self.graph plotWithIdentifier:@"GRAVZ"];
    gravZ.hidden = !gravZ.hidden;
    self.showGravity = !self.showGravity;
}

- (IBAction)pressedRotRate:(UIButton *)button
{
    if (self.showRotRate) {
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    }
    CPTPlot *rotX = [self.graph plotWithIdentifier:@"ROTX"];
    rotX.hidden = !rotX.hidden;
    CPTPlot *rotY = [self.graph plotWithIdentifier:@"ROTY"];
    rotY.hidden = !rotY.hidden;
    CPTPlot *rotZ = [self.graph plotWithIdentifier:@"ROTZ"];
    rotZ.hidden = !rotZ.hidden;
    self.showRotRate = !self.showRotRate;
}

@end
