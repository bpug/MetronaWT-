﻿namespace Metrona.Wt.Database.Repositories.Core
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Provides extension methods for the <see cref="IReadOnlyRepository{T}"/> and <see cref="IRepository{T}"/> interfaces.
    /// </summary>
    public static class IRepositoryExtensions
    {
        /// <summary>
        /// Retrieves all items in the repository satisfied by the specified query asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <param name="queryShaper">The <see cref="Func{T,TResult}">function</see> that shapes the <see cref="IQueryable{T}">query</see> to execute.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the retrieved <see cref="IEnumerable{T}">sequence</see>
        /// of <typeparamref name="T">items</typeparamref>.</returns>
        public static Task<IEnumerable<T>> GetAsync<T>( this IReadOnlyRepository<T> repository, Func<IQueryable<T>, IQueryable<T>> queryShaper ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Requires( queryShaper != null );
            Contract.Ensures( Contract.Result<Task<IEnumerable<T>>>() != null );
            return repository.GetAsync( queryShaper, CancellationToken.None );
        }

        /// <summary>
        /// Retrieves a query result asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <typeparam name="TResult">The <see cref="Type">type</see> of result to retrieve.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <param name="queryShaper">The <see cref="Func{T,TResult}">function</see> that shapes the <see cref="IQueryable{T}">query</see> to execute.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the <typeparamref name="TResult">result</typeparamref> of the operation.</returns>
        public static Task<TResult> GetAsync<T, TResult>( this IReadOnlyRepository<T> repository, Func<IQueryable<T>, TResult> queryShaper ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Requires( queryShaper != null );
            Contract.Ensures( Contract.Result<Task<TResult>>() != null );
            return repository.GetAsync( queryShaper, CancellationToken.None );
        }

        /// <summary>
        /// Retrieves all items in the repository asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the <see cref="IEnumerable{T}">sequence</see>
        /// of all <typeparamref name="T">items</typeparamref> in the repository.</returns>
        public static Task<IEnumerable<T>> GetAllAsync<T>( this IReadOnlyRepository<T> repository ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Ensures( Contract.Result<Task<IEnumerable<T>>>() != null );
            return repository.GetAsync( q => q, CancellationToken.None );
        }

        /// <summary>
        /// Retrieves all items in the repository asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <param name="cancellationToken">The <see cref="CancellationToken">cancellation token</see> that can be used to cancel the operation.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the <see cref="IEnumerable{T}">sequence</see>
        /// of all <typeparamref name="T">items</typeparamref> in the repository.</returns>
        public static Task<IEnumerable<T>> GetAllAsync<T>( this IReadOnlyRepository<T> repository, CancellationToken cancellationToken ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Ensures( Contract.Result<Task<IEnumerable<T>>>() != null );
            return repository.GetAsync( q => q, cancellationToken );
        }

        /// <summary>
        /// Searches for items in the repository that match the specified predicate asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <param name="predicate">The <see cref="Expression{T}">expression</see> representing the predicate used to
        /// match the requested <typeparamref name="T">items</typeparamref>.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the matched <see cref="IEnumerable{T}">sequence</see>
        /// of <typeparamref name="T">items</typeparamref>.</returns>
        public static Task<IEnumerable<T>> FindByAsync<T>( this IReadOnlyRepository<T> repository, Expression<Func<T, bool>> predicate ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Requires( predicate != null );
            Contract.Ensures( Contract.Result<Task<IEnumerable<T>>>() != null );
            return repository.GetAsync( q => q.Where( predicate ), CancellationToken.None );
        }

        /// <summary>
        /// Searches for items in the repository that match the specified predicate asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <param name="predicate">The <see cref="Expression{T}">expression</see> representing the predicate used to
        /// match the requested <typeparamref name="T">items</typeparamref>.</param>
        /// <param name="cancellationToken">The <see cref="CancellationToken">cancellation token</see> that can be used to cancel the operation.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the matched <see cref="IEnumerable{T}">sequence</see>
        /// of <typeparamref name="T">items</typeparamref>.</returns>
        public static Task<IEnumerable<T>> FindByAsync<T>( this IReadOnlyRepository<T> repository, Expression<Func<T, bool>> predicate, CancellationToken cancellationToken ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Requires( predicate != null );
            Contract.Ensures( Contract.Result<Task<IEnumerable<T>>>() != null );
            return repository.GetAsync( q => q.Where( predicate ), cancellationToken );
        }
        

        /// <summary>
        /// Retrieves a single item in the repository matching the specified predicate asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <param name="predicate">The <see cref="Expression{T}">expression</see> representing the predicate used to
        /// match the requested <typeparamref name="T">item</typeparamref>.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the matched <typeparamref name="T">item</typeparamref>
        /// or null if no match was found.</returns>
        public static Task<T> GetSingleAsync<T>( this IReadOnlyRepository<T> repository, Expression<Func<T, bool>> predicate ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Requires( predicate != null );
            Contract.Ensures( Contract.Result<Task<T>>() != null );
            return repository.GetSingleAsync( predicate, CancellationToken.None );
        }

        /// <summary>
        /// Retrieves a single item in the repository matching the specified predicate asynchronously.
        /// </summary>
        /// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        /// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        /// <param name="predicate">The <see cref="Expression{T}">expression</see> representing the predicate used to
        /// match the requested <typeparamref name="T">item</typeparamref>.</param>
        /// <param name="cancellationToken">The <see cref="CancellationToken">cancellation token</see> that can be used to cancel the operation.</param>
        /// <returns>A <see cref="Task{T}">task</see> containing the matched <typeparamref name="T">item</typeparamref>
        /// or null if no match was found.</returns>
        
        public static async Task<T> GetSingleAsync<T>( this IReadOnlyRepository<T> repository, Expression<Func<T, bool>> predicate, CancellationToken cancellationToken ) where T : class
        {
            Contract.Requires( repository != null );
            Contract.Requires( predicate != null );
            Contract.Ensures( Contract.Result<Task<T>>() != null );
            var items = await repository.GetAsync( q => q.Where( predicate ), cancellationToken );
            return items.SingleOrDefault();
        }


        //public static Task<PagedCollection<T>> PaginateAsync<T>( this IReadOnlyRepository<T> repository, int pageIndex, int pageSize ) where T : class
        //{
        //    Contract.Requires( repository != null );
        //    Contract.Requires( pageIndex >= 0 );
        //    Contract.Requires( pageSize >= 1 );
        //    Contract.Ensures( Contract.Result<Task<PagedCollection<T>>>() != null );
        //    return repository.PaginateAsync( pageIndex, pageSize, CancellationToken.None );
        //}
       
        //public static async Task<PagedCollection<T>> PaginateAsync<T>( this IReadOnlyRepository<T> repository, int pageIndex, int pageSize, CancellationToken cancellationToken ) where T : class
        //{
        //    Contract.Requires( repository != null );
        //    Contract.Requires( pageIndex >= 0 );
        //    Contract.Requires( pageSize >= 1 );
        //    Contract.Ensures( Contract.Result<Task<PagedCollection<T>>>() != null );

        //    var groups = await repository.GetAsync(
        //        q =>
        //        {
        //            var startIndex = pageIndex * pageSize;
        //            return q.Skip( startIndex )
        //                    .Take( pageSize )
        //                    .GroupBy(
        //                        g => new
        //                        {
        //                            Total = q.Count()
        //                        } );
        //        },
        //        cancellationToken );

        //    // return first group
        //    var result = groups.FirstOrDefault();

        //    if ( result == null )
        //        return new PagedCollection<T>( Enumerable.Empty<T>(), 0L );

        //    return new PagedCollection<T>( result, result.Key.Total );
        //}

        //public static Task<PagedCollection<T>> PaginateAsync<T>( this IReadOnlyRepository<T> repository, Func<IQueryable<T>, IQueryable<T>> queryShaper, int pageIndex, int pageSize ) where T : class
        //{
        //    Contract.Requires( repository != null );
        //    Contract.Requires( pageIndex >= 0 );
        //    Contract.Requires( pageSize >= 1 );
        //    Contract.Ensures( Contract.Result<Task<PagedCollection<T>>>() != null );
        //    return repository.PaginateAsync( queryShaper, pageIndex, pageSize, CancellationToken.None );
        //}

        //public static async Task<PagedCollection<T>> PaginateAsync<T>( this IReadOnlyRepository<T> repository, Func<IQueryable<T>, IQueryable<T>> queryShaper, int pageIndex, int pageSize, CancellationToken cancellationToken ) where T : class
        //{
        //    Contract.Requires( repository != null );
        //    Contract.Requires( pageIndex >= 0 );
        //    Contract.Requires( pageSize >= 1 );
        //    Contract.Ensures( Contract.Result<Task<PagedCollection<T>>>() != null );

        //    var groups = await repository.GetAsync(
        //                        q =>
        //                        {
        //                            var query = queryShaper( q );
        //                            var startIndex = pageIndex * pageSize;
        //                            return query.Skip( startIndex )
        //                                        .Take( pageSize )
        //                                        .GroupBy(
        //                                            g => new
        //                                            {
        //                                                Total = query.Count()
        //                                            } );
        //                        },
        //                        cancellationToken );

        //    // return first group
        //    var result = groups.FirstOrDefault();

        //    if ( result == null )
        //        return new PagedCollection<T>( Enumerable.Empty<T>(), 0L );

        //    return new PagedCollection<T>( result, result.Key.Total );
        //}

        ///// <summary>
        ///// Saves all pending changes in the repository asynchronously.
        ///// </summary>
        ///// <typeparam name="T">The <see cref="Type">type</see> of item in the repository.</typeparam>
        ///// <param name="repository">The extended <see cref="IReadOnlyRepository{T}">repository</see>.</param>
        ///// <returns>A <see cref="Task">task</see> representing the save operation.</returns>
        //[SuppressMessage( "Microsoft.Design", "CA1062:Validate arguments of public methods", MessageId = "0", Justification = "Validated by a code contract." )]
        //public static Task SaveChangesAsync<T>( this IRepository<T> repository ) where T : class
        //{
        //    Contract.Requires( repository != null );
        //    Contract.Ensures( Contract.Result<Task>() != null );
        //    return repository.SaveChangesAsync( CancellationToken.None );
        //}
    }
}
