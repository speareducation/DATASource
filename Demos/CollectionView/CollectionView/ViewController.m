#import "ViewController.h"

#import "DATAStack.h"
#import "DATASource.h"
#import "User.h"

static NSString *CellIdentifier = @"CollectionViewCell";

@interface ViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) DATAStack *dataStack;
@property (nonatomic) DATASource *dataSource;

@end

@implementation ViewController

- (instancetype)initWithLayout:(UICollectionViewLayout *)layout
                  andDataStack:(DATAStack *)dataStack {
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    _dataStack = dataStack;

    return self;
}

- (DATASource *)dataSource {
    if (_dataSource) return _dataSource;

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];

    _dataSource = [[DATASource alloc] initWithCollectionView:self.collectionView
                                                fetchRequest:request
                                                 sectionName:@"firstLetterOfName"
                                              cellIdentifier:CellIdentifier
                                                 mainContext:self.dataStack.mainContext
                                               configuration:^(UICollectionViewCell *cell, id item, NSIndexPath *indexPath) {
                                                   cell.backgroundColor = [UIColor redColor];
                                               }];

    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:CellIdentifier];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = item;
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KSSWorkListHeaderView"];
}

- (void)addAction {
    [self.dataStack performInNewBackgroundContext:^(NSManagedObjectContext *backgroundContext) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                                  inManagedObjectContext:backgroundContext];
        User *user = [[User alloc] initWithEntity:entity
                   insertIntoManagedObjectContext:backgroundContext];
        NSString *name = [self randomString];
        NSString *firstLetter = [[name substringToIndex:1] uppercaseString];
        [user setValue:name forKey:@"name"];
        [user setValue:firstLetter forKey:@"firstLetterOfName"];
        [backgroundContext save:nil];
    }];
}

- (NSString *)randomString {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity:10];

    for (int i = 0; i < 10; i++) {
        u_int32_t rnd = (u_int32_t)[letters length];
        [randomString appendFormat: @"%C", [letters characterAtIndex:arc4random_uniform(rnd)]];
    }

    return randomString;
}

@end
