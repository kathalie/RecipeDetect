//
//  CGAL.h
//  CGALWrapper
//
//  Created by Kathryn Verkhogliad on 23.06.2024.
//

#ifndef CGAL_WRAPPER_H
#define CGAL_WRAPPER_H

//#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
//#include <CGAL/Triangulation_3.h>
//#include <vector>
//
//typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
//typedef K::Point_3 Point_3;
//typedef CGAL::Triangulation_3<K> Delaunay;


#ifdef __cplusplus
extern "C" {
#endif

char* test();
//float calculate_volume(Point_3* points, std::size_t num_points);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // CGAL_WRAPPER_H
