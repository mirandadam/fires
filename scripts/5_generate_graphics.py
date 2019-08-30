import csv
import numpy as np
import matplotlib.pyplot as plt


def plot_graph(p):
    file_name = p['file_name']
    title = p['title']
    name_column = p['name_column']
    x_column = p['x_column']
    y_columns = p['y_columns']
    max_lines = p['max_lines']
    plot_order = False

    ax0 = plt.figure(title,figsize=(10, 6))
    plt.title(title)
    w = list(csv.DictReader(open(file_name, 'r')))
    for n, yc in enumerate(y_columns):
        data_points = {}
        for i in w:
            name = i[name_column]
            if name not in data_points:
                data_points[name] = []
            data_points[name].append([
                float(i[x_column]),
                float(i[yc])
            ])
        ax1 = plt.subplot(int(str(str(len(y_columns))+'1'+str(n+1))))
        if not plot_order:
            plt.title(title)
        ax1.set_xlabel(x_column)
        ax1.set_ylabel(yc)
        xticks = set()
        if not plot_order:
            plot_order = sorted(list(data_points.items()),
                                key=lambda x: x[1][-1][-1],
                                reverse=True)
            if len(plot_order) > max_lines:
                plot_order = plot_order[:max_lines]
        else:
            plot_order = sorted(list([aux[0], data_points[aux[0]]] for aux in plot_order),
                                key=lambda x: x[1][-1][-1],
                                reverse=True)
        for name, points in plot_order:
            print(title, name, points)
            p = np.array(points)
            p = p[np.argsort(p[:, 0])]
            xticks.update(set(p[:, 0]))
            plt.plot(p[:, 0], p[:, 1], label=name)
        plt.xticks(sorted(list(xticks)), rotation=-45)
        # ax1.legend(bbox_to_anchor=(0.0, -0.4, 1., .102), loc=2,
        #           ncol=3, mode="expand", borderaxespad=0.5)
        ax1.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
    ax0.tight_layout()
    plt.savefig('../graphics/s_'+title+'.svg')
    plt.savefig('../graphics/p_'+title+'.png')


graphics = [
    {
        'file_name': 'modis_amazon_fires_by_country.csv',
        'title': 'MODIS Amazon fires by country',
        'name_column': 'Country',
        'x_column': 'Year',
        'y_columns': ['MODIS Fires', 'MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'modis_amazon_fires_by_country_until_aug_27.csv',
        'title': 'MODIS Amazon fires by country until Aug 27 of each year',
        'name_column': 'Country',
        'x_column': 'Year',
        'y_columns': ['MODIS Fires', 'MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'modis_amazon_fires_by_municipality_until_aug_27.csv',
        'title': 'MODIS Amazon fires by municipality until Aug 27 of each year',
        'name_column': 'Municipality',
        'x_column': 'Year',
        'y_columns': ['MODIS Fires', 'MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'modis_amazon_fires_by_state_until_aug_27.csv',
        'title': 'MODIS Amazon fires by state until Aug 27 of each year',
        'name_column': 'State',
        'x_column': 'Year',
        'y_columns': ['MODIS Fires', 'MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'modis_fires_by_country.csv',
        'title': 'MODIS fires by country',
        'name_column': 'Country',
        'x_column': 'Year',
        'y_columns': ['MODIS Fires', 'MODIS Fires per 1000km2'],
        # 'y_columns': ['MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'viirs_amazon_fires_by_country_until_aug_27.csv',
        'title': 'VIIRS Amazon fires by country until Aug 27 of each year',
        'name_column': 'Country',
        'x_column': 'Year',
        'y_columns': ['VIIRS Fires', 'VIIRS Fires per 1000km2'],
        # 'y_columns': ['MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'viirs_amazon_fires_by_country.csv',
        'title': 'VIIRS Amazon fires by country',
        'name_column': 'Country',
        'x_column': 'Year',
        'y_columns': ['VIIRS Fires', 'VIIRS Fires per 1000km2'],
        # 'y_columns': ['MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'viirs_amazon_fires_by_municipality_until_aug_27.csv',
        'title': 'VIIRS Amazon fires by municipality until Aug 27 of each year',
        'name_column': 'Municipality',
        'x_column': 'Year',
        'y_columns': ['VIIRS Fires', 'VIIRS Fires per 1000km2'],
        # 'y_columns': ['MODIS Fires per 1000km2'],
        'max_lines': 10
    },
    {
        'file_name': 'viirs_amazon_fires_by_state_until_aug_27.csv',
        'title': 'VIIRS Amazon fires by state until Aug 27 of each year',
        'name_column': 'State',
        'x_column': 'Year',
        'y_columns': ['VIIRS Fires', 'VIIRS Fires per 1000km2'],
        # 'y_columns': ['MODIS Fires per 1000km2'],
        'max_lines': 10
    }


]

for p in graphics:
    plot_graph(p)

plt.show()
